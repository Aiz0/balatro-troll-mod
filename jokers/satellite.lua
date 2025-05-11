return {
    key = "satellite",
    base_rate = 0,
    satellites = 0,
    add_to_deck = function(self, card, from_debuff)
        if self.satellites == 0 then
            base_rate = G.GAME.planet_rate
            G.GAME.planet_rate = 0
            G.P_CENTERS.p_celestial_normal_1.weight = 0
            G.P_CENTERS.p_celestial_normal_2.weight = 0
            G.P_CENTERS.p_celestial_normal_3.weight = 0
            G.P_CENTERS.p_celestial_normal_4.weight = 0
            G.P_CENTERS.p_celestial_jumbo_1.weight = 0
            G.P_CENTERS.p_celestial_jumbo_2.weight = 0
            G.P_CENTERS.p_celestial_mega_1.weight = 0
            G.P_CENTERS.p_celestial_mega_2.weight = 0
        end
        self.satellites = self.satellites + 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        self.satellites = self.satellites - 1
        if self.satellites == 0 then
            G.P_CENTERS.p_celestial_normal_1.weight = 0.3
            G.P_CENTERS.p_celestial_normal_2.weight = 0.3
            G.P_CENTERS.p_celestial_normal_3.weight = 0.3
            G.P_CENTERS.p_celestial_normal_4.weight = 0.3
            G.P_CENTERS.p_celestial_jumbo_1.weight = 0.3
            G.P_CENTERS.p_celestial_jumbo_2.weight = 0.3
            G.P_CENTERS.p_celestial_mega_1.weight = 0.3
            G.P_CENTERS.p_celestial_mega_2.weight = 0.3
            G.GAME.planet_rate = self.base_rate
        end
    end,
    calculate = function(self, card, context)
        if context.buying_card then
            if context.card.ability.set == "Voucher" then
                self.base_rate = G.GAME.planet_rate
                G.GAME.planet_rate = 0
            end
        end
    end,
}
