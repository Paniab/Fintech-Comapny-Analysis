import streamlit as st
import requests
import json

# ---- CONFIG ----
WEBHOOK_URL = "http://localhost:5678/webhook-test/get-loan"


# ---- UI ----
st.set_page_config(page_title="Loan Assistant", layout="centered")

st.title("Loan AI Assistant")

loan_id = st.text_input("Enter your Loan ID")
user_query = st.text_area("Ask your question about your loan")

submit = st.button("Answer")



# ---- ACTION ----
if submit:
    if not loan_id or not user_query:
        st.warning("Please enter both Loan ID and your query.")
    else:
        payload = {
            "loan_id": loan_id,
            "query": user_query
        }

        try:
            response = requests.post(WEBHOOK_URL, json=payload)

            if response.status_code == 200:
                data = response.json()
                
                st.markdown("### AI Response")

                # Pretty print JSON
                st.write(data[0]["response"])

            else:
                st.error(f"Error: {response.status_code}")
                st.text(response.text)

        except Exception as e:
            st.error("Failed to connect to server.")
            st.text(str(e))