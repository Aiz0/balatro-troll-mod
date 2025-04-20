SMODS.Sticker({
    key = "mark_sticker",
    pos = { x = 4, y = 1 }, --invisible
    badge_colour = G.C.MULT,
    rate = 0,
    sets = {
        Joker = false,
    },
})

local space_sounds = { --duration will be removed later since i have no use for it
    { key = "moonbase_alpha_999", duration = 3 },
    { key = "moonbase_alpha_aeiou", duration = 3 },
    { key = "moonbase_alpha_big_american_tts", duration = 2 },
    { key = "moonbase_alpha_brbrbrbrbrbrbrbr", duration = 2.5 },
    { key = "moonbase_alpha_holla_holla_get_dollar", duration = 1.5 },
    { key = "moonbase_alpha_im_laughing_for_real_right_now", duration = 2 },
    { key = "moonbase_alpha_john_madden_football", duration = 5 },
    { key = "moonbase_alpha_mark", duration = 2 },
    { key = "moonbase_alpha_question_mark_exclamation_point", duration = 5 },
    { key = "moonbase_alpha_snake", duration = 3 },
    { key = "moonbase_alpha_uuuuuuueeeeeeeeeeuuuuuuu", duration = 5 },
}

for _, sound in pairs(space_sounds) do
    SMODS.Sound({
        key = sound.key,
        path = sound.key .. ".ogg",
    })
end

local mod_prefix = SMODS.current_mod.prefix

return {
    key = "space",
    config = {
        name = "fj_space", -- calculate may not always return so we disable the normal card behavior
        extra = 4,
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if
            context.before
            and context.cardarea == G.jokers
            and pseudorandom(self.key) < G.GAME.probabilities.normal / card.ability.extra
        then
            local sound = pseudorandom_element(space_sounds, pseudoseed(self.key))
            sendDebugMessage(sound.key)

            local retval = {
                message = localize("k_" .. mod_prefix .. "_" .. sound.key),
                sound = mod_prefix .. "_" .. sound.key,
            }
            if sound.key == "moonbase_alpha_holla_holla_get_dollar" then
                retval.dollars = 1
            elseif sound.key == "moonbase_alpha_im_laughing_for_real_right_now" then
                retval.func = function() level_up_hand(card, context.scoring_name, nil, -1) end
            else
                retval.level_up = true
            end

            if sound.key == "moonbase_alpha_mark" then
                for _, playing_card in pairs(context.scoring_hand) do
                    playing_card:add_sticker("folly_mark_sticker", true)
                end
            elseif sound.key == "moonbase_alpha_question_mark_exclamation_point" then
                -- shuffle jokers cards
                -- for funnsies
                retval.func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("aajk")
                            play_sound("cardSlide1", 0.85)
                            return true
                        end,
                    }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("aajk")
                            play_sound("cardSlide1", 1.15)
                            return true
                        end,
                    }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("aajk")
                            play_sound("cardSlide1", 1)
                            return true
                        end,
                    }))
                    delay(0.5)
                end
            end
            return retval
        end
    end,
}
