# Janhit Mitra

## Overview

**Janhit Mitra** is an innovative application designed to harness the power of AI in addressing societal issues related to governance, policy, inequality, and welfare. This project focuses on enhancing citizen engagement and promoting accountability through two main features: AI-powered chatbots and a complaint management system.

## YouTube Demo Video:
https://youtu.be/1IosJY7mh8o

## Problem Statement

Public service institutions often struggle to effectively communicate available schemes, address citizen grievances, and foster transparency in governance. This project aims to bridge the gap by utilizing AI to streamline information dissemination and complaint resolution, ultimately empowering citizens to participate actively in their community's governance.

## Key Features

1. **AI-Powered Chatbots:**
   - **Scheme Recommendation Chatbot:** 
     - Provides recommendations based on user queries about government schemes, FAQs, and application procedures.
   - **PDF Interaction Chatbot:** 
     - Simplifies PDF documents and allows users to ask questions about the data contained within these documents.

2. **Citizen Complaint Management System:**
   - Citizens can raise complaints regarding local issues by submitting an image, location, and description.
   - Complaints are directed to the corresponding corporator based on the geographical location.
   - After resolving a complaint, corporators submit proof of work and generate an upvote ticket.
   - Citizens can upvote the resolved complaint. Once the upvote count reaches a threshold, the complaint status is updated to resolved; otherwise, it remains pending.
   - Each corporator is assigned a unique email ID and password to log in and manage complaints in their jurisdiction.

## Technology Stack

- **Frontend:** Flutter
- **Backend:** Firebase, Firestore
- **Chatbot Frameworks:**
  - **Gorq-Llama** for scheme recommendation and FAQs.
  - **Botpress** for general queries.
  - **Gemma** and **BAAI-bge-small** for PDF chat functionality.

## How It Works

1. **User Interaction:**
   - Users can access chatbots to obtain information on government schemes and clarify doubts related to PDF documents.
   - Users can log complaints with relevant details, including images and location.

2. **Complaint Handling:**
   - Complaints are forwarded to the respective corporator based on the user's location.
   - Corporators can view complaints, provide resolutions, and submit evidence of their work.
   - Citizens can verify the resolution and upvote the complaint if satisfied.

3. **Governance and Accountability:**
   - The upvote system enhances citizen participation in governance by enabling them to hold corporators accountable for their actions.
