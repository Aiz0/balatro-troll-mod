return {
    key = "satellite",
    base_rate = folly_utils.stack(),
    add_to_deck = function(self, card, from_debuff)
        self.base_rate:push(G.GAME.planet_rate)
        G.GAME.planet_rate = 0;
        G.P_CENTERS.p_celestial_normal_1.weight = 0
        G.P_CENTERS.p_celestial_normal_2.weight = 0
        G.P_CENTERS.p_celestial_normal_3.weight = 0
        G.P_CENTERS.p_celestial_normal_4.weight = 0
        G.P_CENTERS.p_celestial_jumbo_1.weight = 0
        G.P_CENTERS.p_celestial_jumbo_2.weight = 0
        G.P_CENTERS.p_celestial_mega_1.weight = 0
        G.P_CENTERS.p_celestial_mega_2.weight = 0
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.planet_rate = self.base_rate:pop()
        if self.base_rate.count == 0 then
            G.P_CENTERS.p_celestial_normal_1.weight = 0.3
            G.P_CENTERS.p_celestial_normal_2.weight = 0.3
            G.P_CENTERS.p_celestial_normal_3.weight = 0.3
            G.P_CENTERS.p_celestial_normal_4.weight = 0.3
            G.P_CENTERS.p_celestial_jumbo_1.weight = 0.3
            G.P_CENTERS.p_celestial_jumbo_2.weight = 0.3
            G.P_CENTERS.p_celestial_mega_1.weight = 0.3
            G.P_CENTERS.p_celestial_mega_2.weight = 0.3
        end
        end,
}