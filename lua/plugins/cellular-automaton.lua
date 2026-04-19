local nmap = require('utils.map').nmap

return {
    'eandrju/cellular-automaton.nvim',
    config = function()
        local ca = require 'cellular-automaton'
        -- nmap('<leader>m', fn(ca.start_animation, 'make_it_rain'), 'make it rain')

        ca.register_animation(require 'ca_anims.donut')

        local anims = {
            [1] = function()
                ca.start_animation 'make_it_rain'
            end,
            [2] = function()
                ca.start_animation 'game_of_life'
            end,
            [3] = function()
                ca.start_animation 'donut'
            end,
            [4] = function()
                ca.start_animation 'scramble'
            end,
        }
        nmap('<leader>m', function()
            local count = vim.v.count
            if count == 0 then
                count = 1
            end
            if count > 4 then
                count = 4
            end
            local ca_anim_startfn = anims[count]
            if ca_anim_startfn then
                ca_anim_startfn()
            end
        end, 'cell.auto.', { noremap = false })
    end,
}
