import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-rails'
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
  resolve: {
    dedupe: ['axios']
  },
  plugins: [
    RubyPlugin(),
    svelte()
  ]
})
