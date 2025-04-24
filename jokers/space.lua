SMODS.Sticker({
    key = "mark_sticker",
    pos = { x = 4, y = 1 }, --invisible
    badge_colour = G.C.MULT,
    rate = 0,
    sets = {
        Joker = false,
    },
})

local space_sounds = {
    "moonbase_alpha_999",
    "moonbase_alpha_aeiou",
    "moonbase_alpha_big_american_tts",
    "moonbase_alpha_brbrbrbrbrbrbrbr",
    "moonbase_alpha_holla_holla_get_dollar",
    "moonbase_alpha_im_laughing_for_real_right_now",
    "moonbase_alpha_john_madden_football",
    "moonbase_alpha_mark",
    "moonbase_alpha_question_mark_exclamation_point",
    "moonbase_alpha_snake",
    "moonbase_alpha_uuuuuuueeeeeeeeeeuuuuuuu",
}

for _, sound in pairs(space_sounds) do
    SMODS.Sound({
        key = sound,
        path = sound .. ".ogg",
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

            local retval = {
                message = localize("k_" .. mod_prefix .. "_" .. sound),
                sound = mod_prefix .. "_" .. sound,
            }
            if sound == "moonbase_alpha_holla_holla_get_dollar" then
                retval.dollars = 1
            elseif sound == "moonbase_alpha_im_laughing_for_real_right_now" then
                retval.func = function() level_up_hand(card, context.scoring_name, nil, -1) end
            elseif sound == "moonbase_alpha_big_american_tts" then
                -- level up twice
                -- "Holy cow, two big ones" - Northernlion
                retval.func = function() level_up_hand(card, context.scoring_name, nil, 2) end
            else
                retval.level_up = true
            end

            if sound == "moonbase_alpha_mark" then
                for _, playing_card in pairs(context.scoring_hand) do
                    playing_card:add_sticker("folly_mark_sticker", true)
                end
            elseif sound == "moonbase_alpha_question_mark_exclamation_point" then
                -- shuffle jokers cards
                -- for funnsies
                retval.func = function() folly_utils.shuffle_cardarea() end
            elseif sound == "moonbase_alpha_aeiou" then
                -- shuffle played cards
                retval.func = function() folly_utils.shuffle_cardarea(G.play) end
            end
            return retval
        end
    end,
}
