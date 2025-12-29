return {
  'EggbertFluffle/beepboop.nvim',
  opts = {
    audio_player = 'afplay',
    max_sounds = 20,
    sound_map = {
      { auto_command = 'VimEnter', sound = 'chestopen.oga' },
      { auto_command = 'InsertCharPre', sounds = { 'stone1.oga', 'stone2.oga', 'stone3.oga' } },
    },
  },
}
