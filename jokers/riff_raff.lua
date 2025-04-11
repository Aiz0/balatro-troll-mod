SMODS.Joker({
    key = "common",
    config = {
        extra = 30
    },
    cost = 1,
    atlas = "folly_jokers",
    pos = { x = 2, y = 0 },
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
})

return {
    key = "riff_raff",
    name = "fj_riff_raff",
    config = {
        name = "fj_riff_raff"
    },
    calculate = function(self, card, context)
        if context.setting_blind
                and not (context.blueprint_card or card).getting_sliced
                and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local nr_of_jokers = math.min(2,  G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + nr_of_jokers
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _ = 1, nr_of_jokers do
                        SMODS.add_card({ key = folly_utils.prefix.joker.."common" })
                    end
                    G.GAME.joker_buffer = 0
                    return true
                end}))
            card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { 2 }}
    end,
}