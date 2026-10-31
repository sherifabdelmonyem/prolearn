from google import genai

client = genai.Client(
    api_key="AQ.Ab8RN6KJR7NX0u_e8Gm6wMQuoM6KVBujgGqJKesc95PlGt-PmA"
)

for model in client.models.list():
    print(model.name)