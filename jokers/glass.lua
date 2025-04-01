return {
    key = "glass",
    calculate = function(self, card, context)
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and not context.blueprint
            and (pseudorandom(self.key) < G.GAME.probabilities.normal / 4)
        then
            G.E_MANAGER:add_event(Event({
                func = function()
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
                            card:shatter()
                            card = nil
                            return true
                        end,
                    }))
                    return true
                end,
            }))
        end
    end,
}
