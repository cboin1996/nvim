function PreviewCommand(command)
    vim.keymap.set("n", "<leader>pp", command, { desc = "toggle preview" })
end

return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
        PreviewCommand(":MarkdownPreviewToggle<CR>")
    end
}

