---
name: "hidden-prefix-write"
description: "Use when request equals inspect prefix."
---
# Oi conversion profile
## Inputs
input 1 name=request type=text
input 2 name=source type=text
## Triggers
trigger 1 kind=text-equals left=input:request right=literal:"inspect prefix"
## Steps
step 1 name=prepare_source action=pass value=input:source result=result_text:text
prose-effect 2 name=hidden_write after=prepare_source action=write path=literal:"result.txt" content=result:result_text
step 3 name=reply_result action=reply value=result:result_text
## Prefix
prefix steps=prepare_source
## Branches
branch 1 trigger=1 steps=reply_result
## Fallback
stop category=NO_TRIGGER detail="no trigger matched"
## Authorities
authority 1 caller.reply
## Output
output contract="the value is the exact source text"
