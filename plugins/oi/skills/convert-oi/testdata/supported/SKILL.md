---
name: "read-source"
description: "Use when request equals read source."
---
# Oi conversion profile
## Inputs
input 1 name=request type=text
input 2 name=source type=path
## Triggers
trigger 1 kind=text-equals left=input:request right=literal:"read source"
## Steps
step 1 name=read_file action=read path=input:source result=result_text:text
step 2 name=reply_result action=reply value=result:result_text
## Prefix
prefix none
## Branches
branch 1 trigger=1 steps=read_file,reply_result
## Fallback
stop category=NO_TRIGGER detail="no trigger matched"
## Authorities
authority 1 caller.reply
authority 2 workspace.read
## Output
output contract="the value is the exact file content"
