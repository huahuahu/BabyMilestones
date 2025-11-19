---
agent: agent
description: Extract data from the given file and rewrite it in csv format.
tools: ['edit', 'search', 'fetch', 'runSubagent']
---
You would be given a file. The file contains some data in it. Your task is to extract the data from the file rewrite in csv format.
The content are copied from table in PDF file. So there is no line breaks between rows. 
You should 
1. Identify the columns from the data.
2. Separate the rows correctly.
3. Rewrite the data in csv format.
4. Make sure the csv data is correct and clean.
5. If the first column is about age. Make the age unit as month. For example, “1岁1月” should be converted to “13月”. If not, keep the original value.
6. Keep the column headers not changed.