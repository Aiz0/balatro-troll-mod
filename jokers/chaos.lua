return {
    key="chaos",
    set_ability = function (self, card)
        -- extra is 1 so i just put it in ability directly
        -- also lmao if you get a 2nd chaos it will have the same value
        card.ability.random = pseudorandom(self.key)
    end
}
