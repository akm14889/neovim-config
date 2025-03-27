1. Analyze the input content and extract static structures or relationships:
   - If the content describes inheritance, dependency, association, or implementation relationships between classes, methods, functions, or classes and functions, use `classDiagram`.
   - If the content describes state transitions or process steps, use `stateDiagram` or `flowchart`.
   - Extract the core structure: classes, attributes, methods, functions, and their relationships.
2. Extract the core elements from the structure:
   - **classDiagram**:
     - Extract class names, attributes, and methods.
     - Define static relationships between classes (e.g., inheritance, implementation, dependency).
     - Define static relationships between functions, functions and classes, or methods.
   - **stateDiagram** or **flowchart**:
     - Define nodes as states or steps, showing associations or transitions.
     - Use arrows to represent transitions between states.
3. If the input is code, follow these guidelines:
   1. Analyze the input content and extract classes, attributes, methods, functions, and their static relationships:
      - Name each class or function based on its functionality.
      - Extract class attributes and methods, displaying them within the class node.
      - Define inheritance, implementation, or dependency relationships between classes.
      - Define associations between functions, methods, or classes.
   2. Convert the extracted static structure into Mermaid’s `classDiagram` syntax:
      - Represent each class with `class`, including its attributes and methods.
      - Represent each function with `class` and show its relationships with other elements in the class diagram.
      - Use arrows like inheritance (`<|--`), implementation (`<|..`), dependency (`..>`), or association (`--`) to describe relationships between classes, methods, and functions.
   3. Adjust the output node names and connection descriptions:
      - Add descriptive names to class or function nodes.
      - Clearly label the relationship type next to connections (e.g., “depends on,” “implements,” “calls”).
   4. Additionally generate a simplified version of the diagram:
      - Retain only class names, main methods, and key relationships.
      - Focus on the most important structure, omitting minor details.
4. Provide an online accessible Http link to view the Mermaid diagram:
   - Print only the accessible URL without GET parameters or Markdown hyperlink syntax
     - For example: https://mermaid-js.github.io/mermaid-live-editor/edit
