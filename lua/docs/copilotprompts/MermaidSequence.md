1. Analyze the input content and extract the specific process or logical structure:
   - If the content describes execution steps, operation sequences, or timelines, use sequenceDiagram.
   - If the content describes decision trees, branches, or state transitions, use flowchart.
2. Extract the core elements and their interactions in the process:
   - sequenceDiagram:
     - Identify the main participants and their behaviors.
     - Define the sequence and interactions between behaviors (e.g., requests and responses).
   - flowchart:
     - Define nodes as individual steps or states.
     - Use arrows to show transitions between states or steps.
3. If the input is code, follow these guidelines:
   1. First, list all custom classes, functions, and methods, then proceed with the analysis.
   2. Analyze the input content, extracting functions, parameters, and their call relationships:
      - Treat each function as a node, named according to its specific functionality.
      - Extract the call parameters and return values of each function, displayed next to the arrows.
   3. Convert the extracted functions and parameters into Mermaid sequenceDiagram syntax:
      - Represent each node with participant.
      - Ensure all custom classes, functions, and methods listed earlier are represented as participant.
      - Use arrows to indicate the direction of function calls and their parameters.
   4. Adjust the output node names and arrow descriptions:
      - Add descriptive labels to nodes.
      - Display specific parameters of function calls next to the arrows.
   5. Additionally, generate a simplified version of the diagram:
      - Retain only the important parameters.
      - Pay special attention to preserving specific parameter descriptions.
4. Provide an HTTP link to view the Mermaid diagram online:
   - Print only the accessible URL without GET parameters or Markdown hyperlinks.
   - For example: https://mermaid-js.github.io/mermaid-live-editor/edit
