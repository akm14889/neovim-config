# CopilotChat.nvim Usage Guide

## Configuration Setup

1. Replace your current `lua/ananya/plugins/copilot.lua` with the provided configuration.
2. Ensure all your prompt files are in the correct location at `lua/docs/copilotprompts/`.

## Key Features

The configuration provides several ways to interact with CopilotChat:

### 1. Keybindings

All keybindings use `<leader>z` as the prefix (where `<leader>` is typically the space key):

| Keybinding   | Mode          | Description                                |
| ------------ | ------------- | ------------------------------------------ |
| `<leader>zc` | Normal        | Open Copilot Chat                          |
| `<leader>zx` | Normal        | Close Copilot Chat                         |
| `<leader>ze` | Normal/Visual | Explain selected code                      |
| `<leader>zr` | Normal/Visual | Review selected code                       |
| `<leader>zf` | Normal/Visual | Fix issues in code                         |
| `<leader>zo` | Normal/Visual | Optimize code                              |
| `<leader>zt` | Normal/Visual | Generate tests                             |
| `<leader>zd` | Normal/Visual | Generate documentation                     |
| `<leader>zg` | Normal        | Quick chat with buffer context             |
| `<leader>zG` | Normal        | Quick chat with input prompt               |
| `<leader>zs` | Normal        | No context chat                            |
| `<leader>zp` | Normal/Visual | Show prompt actions menu                   |
| `<leader>zi` | Normal        | Inline chat with buffer context            |
| `<leader>zI` | Visual        | Inline chat with visual selection          |
| `<leader>zC` | Normal        | Generate commit message                    |
| `<leader>zS` | Normal        | Generate commit message for staged changes |

### 2. Commands

You can also use these commands directly:

- `:CopilotChatOpen` - Open the chat window
- `:CopilotChatClose` - Close the chat window
- `:CopilotChatExplain` - Explain selected code
- `:CopilotChatReview` - Review selected code
- `:CopilotChatFix` - Fix issues in code
- `:CopilotChatOptimize` - Optimize code
- `:CopilotChatTests` - Generate tests
- `:CopilotChatDocs` - Generate documentation
- `:CopilotChatCommit` - Generate commit message
- `:CopilotChatCommitStaged` - Generate commit message for staged changes

### 3. Prompt Actions Menu

You can access all available actions by pressing `<leader>zp` or running `:lua CopilotChatPromptAction()`. This will open a menu with all the available prompt actions including:

- Explain
- Review
- Fix
- Optimize
- Docs
- Tests
- OneLineComment
- OneParagraphComment
- CodeGraph
- MermaidUml
- MermaidSequence
- FixDiagnostic
- Commit
- CommitStaged

## Using Custom Prompts

Your custom prompts are defined in Markdown files located in `lua/docs/copilotprompts/`. Each prompt has a specific purpose:

- `Explain.md` - Detailed explanation of code
- `Review.md` - Code review
- `Fix.md` - Fix issues in code
- `Optimize.md` - Optimize code
- `Docs.md` - Generate documentation
- `Tests.md` - Generate tests
- `CodeGraph.md` - Generate code diagrams
- `MermaidUml.md` - Generate UML diagrams using Mermaid
- `MermaidSequence.md` - Generate sequence diagrams using Mermaid
- `FixDiagnostic.md` - Fix diagnostic issues
- `Commit.md` - Generate commit messages
- `CommitStaged.md` - Generate commit messages for staged changes
- `OneLineComment.md` - Generate one-line comments
- `OneParagraphComment.md` - Generate paragraph comments

## Tips for Effective Use

1. **Visual Selection**: To get the best results, first select the code you want to analyze or modify using visual mode.

2. **Chat Window Navigation**:

   - `q` to close the chat window
   - `<C-l>` to reset the chat
   - `<CR>` (Enter) to submit a prompt in normal mode
   - `<C-s>` to submit a prompt in insert mode
   - `gh` to show help

3. **Working with Diffs**:

   - `gd` to show diff between your code and suggested changes
   - `<C-y>` to accept the suggested changes
   - `gy` to yank (copy) the diff

4. **Sticky Prompts**:

   - `grr` to toggle sticky prompts
   - `grx` to clear all sticky prompts

5. **Advanced Use Cases**:
   - Use `CodeGraph.md` to generate visual representations of code structure
   - Use `MermaidUml.md` to generate UML diagrams
   - Use `FixDiagnostic.md` to get help with error messages

## Example Workflow

1. Open a code file in Neovim
2. Visually select the code you want to work with (press `v` and select lines)
3. Press `<leader>ze` to get an explanation of the selected code
4. In the chat window, you can ask follow-up questions
5. Press `<leader>cf` to get suggestions for fixing issues
6. Press `gd` to see the suggested changes as a diff
7. Press `<C-y>` to apply the changes

## Troubleshooting

If you encounter issues:

1. Check that your prompt files exist in the correct location
2. Verify the file paths in your configuration
3. Check the Neovim logs: `:messages`
4. Make sure you have the required dependencies installed

Remember that changes to the configuration will only take effect after restarting Neovim or reloading the configuration.
