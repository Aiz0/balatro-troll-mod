return {
    key = "cavendish",
    config = {
        extra = {
            odds = 1000,
            rot = 1,
        }
    },
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if pseudorandom(card.key) < G.GAME.probabilities.normal/self.ability.extra.odds then
                card.extra.odds = card.extra.odds - card.extra.rot;
                card.extra.rot = card.extra.rot + 1;
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
                return { message = "Rotten!" }
            end
        end
    end,
}