return {
    key = "astronomer",
    config = {
        extra = {
            astro = nil,
        },
    },
    set_ability = function(self, card, initial, delay_sprites)
        local pool, pool_key = get_current_pool("Planet")
        for i = #pool, 1, -1 do
            if pool[i] == "UNAVAILABLE" then
                table.remove(pool, i)
            end
        end
        card.ability.extra.astro = pseudorandom_element(pool, pseudoseed(pool_key))
    end,
}
