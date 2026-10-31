import edge_tts
import uuid
import os
import asyncio


class VoiceAgent:

    def run(self, text: str):

        if not isinstance(text, str):
            text = str(text)

        text = text.strip()

        output_dir = os.path.join(
            os.getcwd(),
            "uploads",
            "audio",
        )

        os.makedirs(output_dir, exist_ok=True)

        filename = f"{uuid.uuid4()}.mp3"
        path = os.path.join(output_dir, filename)

        print("=" * 60)
        print("VOICE AGENT")
        print("TEXT:", text[:300])
        print("SAVE PATH:", path)
        print("=" * 60)

        async def generate():
            communicate = edge_tts.Communicate(
                text=text,
                voice="ar-EG-ShakirNeural",
                rate="-5%",
            )

            await communicate.save(path)

        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        loop.run_until_complete(generate())
        loop.close()

        print("FILE EXISTS:", os.path.exists(path))
        print("FILE SIZE:", os.path.getsize(path))

        return {
            "status": "ready",
            "provider": "edge-tts",
            "url": f"/uploads/audio/{filename}",
            "path": path,
        };