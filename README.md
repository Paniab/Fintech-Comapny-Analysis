# Fintech-Company-Analysis
Problem Statement

Businesses spend a lot of time manually processing data and generating responses. This project automates the process using n8n workflow automation and Generative AI.

The automation:

Collects data from [source]
Sends it to GenAI
Generates intelligent response
Sends output to [destination]
Workflow 1 Architecture Scheduled Trigger (Monday 9 AM) ↓ Read Binary File (Local CSV) ↓ Extract CSV Node ↓ JavaScript Code Node (Metric Calculation) ↓ OpenAI Node (AI Email Content Generation) ↓ Email Node (Send Report)

Workflow 2 Architecture Webhook Trigger ↓ Initial JavaScript Processing ↓ Read File from Disk ↓ Extract CSV Data ↓ Metric Calculation (JavaScript) ↓ AI Agent (Google Gemini Chat Model) ↓ Final JavaScript Post-Processing

GenAI Usage Input: User data / Form data

Prompt: "Generate a professional summary based on the following data: {{input}}"

Output: AI-generated structured response.

The model used: OpenAI Gemini
