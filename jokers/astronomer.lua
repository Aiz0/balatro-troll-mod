return {
    key = "astronomer",
    old_pool = {},
    softlock = nil,
    astronomers = 0,
    add_to_deck = function(self, card, from_debuff)
        if self.astronomers == 0 then
            local ran = pseudorandom(self.key) * #G.P_CENTER_POOLS.Planet
            local index = math.floor(ran+0.5) -- lua doesn't have rounding lmao
            self.old_pool = G.P_CENTER_POOLS.Planet
            local target = G.P_CENTER_POOLS.Planet[index]
            self.softlock = target.softlock
            target.softlock = nil
            G.P_CENTER_POOLS.Planet = { target }
        end
        self.astronomers = self.astronomers + 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        self.astronomers = self.astronomers - 1
        if self.astronomers == 0 then
            local target = G.P_CENTER_POOLS.Planet[1]
            target.softlock = self.softlock
            G.P_CENTER_POOLS.Planet = self.old_pool
        end
    end,
}