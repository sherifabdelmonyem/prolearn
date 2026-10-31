import asyncio
import edge_tts

TEXT = " االسلام عليكم. هذا اختبار للصوت باللغة العربية من اعداد شريف سيد عبد المنعم."

async def main():
    communicate = edge_tts.Communicate(
        TEXT,
        voice="ar-EG-SalmaNeural",
    )
    await communicate.save("test.mp3")

asyncio.run(main())

print("Done")