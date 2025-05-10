SMODS.Enhancement({
    key = "jimbo",
    atlas = "folly_enhancers",
    pos = { x = 1, y = 0 },
    config = {
        mult = 4,
    },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
})

G.FUNCS.get_most_of_rank = function(hand)
    local vals = {}
    for i = SMODS.Rank.max_id.value, 1, -1 do
        vals[i] = {}
    end
    for i = #hand, 1, -1 do
        if not SMODS.has_enhancement(hand[i], 'm_folly_jimbo') then
            table.insert(vals[hand[i]:get_id()], hand[i])
        end
    end

    local most = 0
    local most_table = {}
    for i, v in pairs(vals) do
        if next(v) then
            if #v == most then
                table.insert(most_table, v)
            elseif #v > most then
                most = #v
                most_table = {}
                table.insert(most_table, v)
            end
        end
    end
    
    local highest = 0
    if next(most_table) then
        for _, v in pairs(most_table) do
            highest = math.max(v[1]:get_id(), highest)
        end
    end

    if highest == 0 then
        return SMODS.Rank.max_id.value
    else
        return highest
    end
end

return {
    key = "joker",
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local created_card = create_playing_card({
                front = pseudorandom_element(G.P_CARDS, pseudoseed('jimbo_fr_fr')),
                center = G.P_CENTERS.c_base}, G.deck, nil, nil, nil, nil)
            created_card:set_ability(G.P_CENTERS.m_folly_jimbo, nil, true)
            play_sound("tarot1")
        end
    end,
    update = function(self, card, dt)
        if card.area == G.jokers then
            card:remove()
        end
    end,
}
