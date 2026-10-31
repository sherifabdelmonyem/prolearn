import os
import cv2
from paddleocr import PaddleOCR

class OCRService:
    def __init__(self):
        self.ocr = PaddleOCR(
            use_angle_cls=False,
            lang='ar',
            det_db_thresh=0.4,       # رفع عتبة الكشف لتجاهل الخلفيات الباهتة
            det_db_box_thresh=0.7,   # رفع دقة قبول المربع لمنع التكرار الوهمي
            unclip_ratio=1.6
        )

    def preprocess_image(self, image_path: str) -> str:
        """معالجة الصورة لإزالة التشوش والظلال ورفع التباين"""
        img = cv2.imread(image_path)
        if img is None:
            return image_path
            
        # تحويل الصورة إلى تدرجات الرمادي (Grayscale)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        # تطبيق عتبة تكارئ (Otsu Thresholding) لتنقية النص وجعل الخلفية بيضاء نقية
        _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        
        # حفظ الصورة المعالجة مؤقتاً
        processed_path = image_path.replace(".", "_processed.")
        cv2.imwrite(processed_path, thresh)
        return processed_path

    def extract_text(self, image_path: str) -> str:
        if not os.path.exists(image_path):
            raise FileNotFoundError(f"Image not found at {image_path}")
            
        # تجهيز الصورة أولاً
        clean_image_path = self.preprocess_image(image_path)
        
        # استخراج النصوص مع تحديد نسبة ثقة لا تقل عن 60%
        result = self.ocr.ocr(clean_image_path, cls=False)
        
        unique_lines = set()  # استخدام Set لمنع تكرار أي جملة تماماً
        ordered_lines = []
        
        if result and result[0]:
            for line in result[0]:
                text = line[1][0].strip()
                confidence = line[1][1]
                
                # تصفية النصوص الضعيفة أو المكررة
                if text and confidence > 0.6 and text not in unique_lines:
                    unique_lines.add(text)
                    ordered_lines.append(text)
                    
        # تنظيف الملف المؤقت
        if clean_image_path != image_path and os.path.exists(clean_image_path):
            os.remove(clean_image_path)
            
        return "\n".join(ordered_lines)

ocr_service = OCRService()