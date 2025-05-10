return {
    key = "cavendish",
    name = "fj_cavendish",
    config = {
        extra = {
            Xmult = 3,
            odds = 1000,
            rot = 1,
        },
        name = "fj_cavendish",
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Xmult,
                G.GAME.probabilities.normal,
                card.ability.extra.odds,
            },
        }
    end,
    calculate = function(self, card, context)
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and not context.blueprint
        then
            if pseudorandom(self.key) >= G.GAME.probabilities.normal / card.ability.extra.odds then
                card.ability.extra.odds = card.ability.extra.odds - card.ability.extra.rot
                card.ability.extra.rot = card.ability.extra.rot * 2
                card.ability.extra.odds = math.max(card.ability.extra.odds, 6)
                return { message = localize("k_safe_ex") }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true
                            end,
                        }))
                        return true
                    end,
                }))
                return { message = localize("j_folly_cavendish") }
            end
        end
    end,
}
