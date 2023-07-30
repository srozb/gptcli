import pyopenai
import json
import os
import strutils
import cligen

var openai = newOpenAiClient(getEnv("OPENAI_API_KEY"))
openai.apiBase = "https://chimeragpt.adventblocks.cc/api/v1"

proc getChatCompletion(prompt: seq[JsonNode], model: string, maxTokens: uint, temperature: float): string = 

  let response = openai.createChatCompletion(
      model = model,
      messages = prompt,
      temperature = temperature,
      maxTokens = maxTokens
  )
  result = response["choices"][0]["message"]["content"].getStr()

proc chatCompletion(
    messages: seq[string], 
    model="gpt-4", 
    maxTokens:uint=2500,
    temperature = 1.0
  ) =

  var chatMessages: seq[JsonNode]
  
  if messages.len == 0:
    while true:
      stdout.write "> "
      chatMessages.add(%*{"role": "user", "content": readLine(stdin)})
      stdout.write "\n ChatGPT: "
      echo getChatCompletion(chatMessages, model, maxTokens, temperature)
  else:
    chatMessages.add(%*{"role": "user", "content": messages.join(messages.join(" "))})
    echo getChatCompletion(chatMessages, model, maxTokens, temperature)

proc imageGen(prompt: seq[string], n:uint = 1, size="1024x1024") = 
  let response = openai.createImage(
    prompt = prompt.join(" "),
    n=n,
    size=size
  )
  # for u in response["data"][0]["url"].getStr()
  for u in response["data"]:
    echo u["url"].getStr()

proc fileChat(
  files: seq[string],
  model="gpt-4", 
  maxTokens:uint=2500,
  temperature = 1.0
  ) =
  var chatMessages: seq[JsonNode]
  for file in files:
    echo file & ">"
    chatMessages.add(%*{"role": "user", "content": file.readFile()})
    stdout.write "\n ChatGPT: "
    echo getChatCompletion(chatMessages, model, maxTokens, temperature)

dispatchMulti([chatCompletion], [imageGen], [fileChat])
