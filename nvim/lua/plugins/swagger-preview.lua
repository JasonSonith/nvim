return {
  "vinnymeller/swagger-preview.nvim",
  cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
  -- The plugin looks for swagger-ui-watcher in its own node_modules, not globally.
  build = "npm ci",
  config = true,
}
