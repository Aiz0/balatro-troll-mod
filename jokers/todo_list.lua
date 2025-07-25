---@param key string
---@return boolean
--- Returns true if pokerhand is visible
local function is_visible(key)
    return G.GAME.hands[key] and G.GAME.hands[key].visible
end

---@param hand Card[]|table[]
--- Returns true if no ranks are next for another rank
local function all_skip_rank(hand)
    local ranks = {}
    for _, playing_card in ipairs(hand) do
        local id = playing_card:get_id()
        if id > 0 then
            for k, v in pairs(SMODS.Ranks) do
                if v.id == id then
                    table.insert(ranks, v)
                    break
                end
            end
        end
    end
    for i, rank in ipairs(ranks) do
        for j, other_rank in ipairs(ranks) do
            if i ~= j then
                if rank == other_rank then
                    return false
                end
                for _, next_rank in ipairs(rank.next) do
                    if SMODS.Ranks[next_rank] == other_rank then
                        return false
                    end
                end
            end
        end
    end
    return true
end
-- spectrum stolen from six suits mod
-- modified to only require 4 suits
local spectrum = SMODS.PokerHandPart({
    key = "spectrum_4",
    func = function(hand)
        local suits = {}
        for _, v in ipairs(SMODS.Suit.obj_buffer) do
            suits[v] = 0
        end
        if #hand < 4 then
            return {}
        end
        local scored = {}
        for i = 1, #hand do
            if not SMODS.has_any_suit(hand[i]) then
                for k, v in pairs(suits) do
                    if hand[i]:is_suit(k, nil, true) and v == 0 then
                        suits[k] = v + 1
                        table.insert(scored, hand[i])
                        break
                    end
                end
            end
        end
        for i = 1, #hand do
            if SMODS.has_any_suit(hand[i]) then
                for k, v in pairs(suits) do
                    if hand[i]:is_suit(k, nil, true) and v == 0 then
                        suits[k] = v + 1
                        table.insert(scored, hand[i])
                        break
                    end
                end
            end
        end
        local num_suits = 0
        for _, v in pairs(suits) do
            if v > 0 then
                num_suits = num_suits + 1
            end
        end
        return (num_suits >= 4) and { scored } or {}
    end,
})

local extra_poker_hands = {}
local poker_hands = {
    jog = SMODS.PokerHand({
        key = "jog",
        mult = 5,
        chips = 30,
        l_mult = 3,
        l_chips = 40,
        visible = false,
        example = {
            { "C_T", true },
            { "D_8", true },
            { "D_6", true },
            { "S_4", true },
            { "H_2", true },
        },
        evaluate = function(parts, hand)
            if not is_visible(extra_poker_hands.jog) then
                return {}
            end
            -- get straighs with skips enabled
            local straights = get_straight(hand, SMODS.four_fingers(), true)
            for i = #straights, 1, -1 do
                --keep if they all skip a rank
                if not all_skip_rank(straights[i]) then
                    table.remove(straights, i)
                end
            end
            return straights
        end,
    }),

    oil_change = SMODS.PokerHand({
        key = "oil_change",
        mult = 20,
        chips = 200,
        l_mult = 5,
        l_chips = 50,
        visible = false,
        example = {
            { "S_K", true, edition = "e_polychrome" },
            { "S_A", true, edition = "e_polychrome" },
            { "D_7", true, enhancement = "m_gold" },
            { "D_2", true, enhancement = "m_gold" },
            { "D_8", true, enhancement = "m_gold" },
        },
        evaluate = function(parts, hand)
            if #hand < 5 or not is_visible(extra_poker_hands.oil_change) then
                return {}
            end
            local oil = 0
            local gold = 0
            for _, playing_card in ipairs(hand) do
                if
                    playing_card:is_suit("Spades")
                    and playing_card.edition
                    and playing_card.edition.polychrome
                then
                    oil = oil + 1
                elseif
                    playing_card:is_suit("Diamonds")
                    and SMODS.has_enhancement(playing_card, "m_gold")
                then
                    gold = gold + 1
                end
            end

            if oil == 2 and gold == 3 then
                return { hand }
            end
            return {}
        end,
    }),

    karate = SMODS.PokerHand({
        key = "karate",
        mult = 6,
        chips = 60,
        l_mult = 4,
        l_chips = 30,
        visible = false,
        example = {
            { "H_K", true },
            { "D_A", true },
            { "S_7", true },
            { "S_2", true },
            { "C_8", true },
        },
        evaluate = function(parts, hand)
            local ret = {}
            if #hand < 5 or not is_visible(extra_poker_hands.karate) then
                return {}
            end

            local karate = { 13, 14, 7, 2, 8 }
            for i = 1, #hand do
                for j = 1, #karate do
                    if hand[i]:get_id() == karate[j] then
                        table.insert(ret, hand[i])
                        table.remove(karate, j)
                        break
                    end
                end
            end
            if #ret == 5 then
                return { ret }
            end
            return {}
        end,
    }),

    eat_candy = SMODS.PokerHand({
        key = "eat_candy",
        chips = 15,
        mult = 2,
        l_chips = 15,
        l_mult = 1,
        visible = false,
        example = {
            { "H_2", true },
            { "C_7", true },
            { "S_J", true },
            { "D_2", true },
            { "D_K", false },
        },
        evaluate = function(parts)
            return is_visible(extra_poker_hands.eat_candy) and parts[spectrum.key] or {}
        end,
    }),

    ruminate = SMODS.PokerHand({
        key = "ruminate",
        mult = 12,
        chips = 100,
        l_mult = 3,
        l_chips = 30,
        visible = false,
        example = {
            { "S_K", true, enhancement = "m_glass" },
            { "S_9", true, enhancement = "m_glass" },
            { "D_9", true, enhancement = "m_glass" },
            { "H_6", true, enhancement = "m_glass" },
            { "D_3", true, enhancement = "m_glass" },
        },
        evaluate = function(parts, hand)
            local ret = {}
            if #hand < 5 or not is_visible(extra_poker_hands.ruminate) then
                return {}
            end
            for i = 1, #hand do
                if SMODS.has_enhancement(hand[i], "m_glass") then
                    table.insert(ret, hand[i])
                end
            end
            if #ret == 5 then
                return { ret }
            end
            return {}
        end,
    }),
}
local extra_poker_hands_set = {}
for key, poker_hand in pairs(poker_hands) do
    extra_poker_hands_set[poker_hand.key] = true
    extra_poker_hands[key] = poker_hand.key
end

return {
    key = "todo_list",
    calculate = function(self, card, context)
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and not context.blueprint
        then
            local _poker_hands = {}
            for key, poker_hand in pairs(G.GAME.hands) do
                if
                    (poker_hand.visible or extra_poker_hands_set[key])
                    and key ~= card.ability.to_do_poker_hand
                then
                    table.insert(_poker_hands, key)
                end
            end
            card.ability.to_do_poker_hand = pseudorandom_element(_poker_hands, pseudoseed("to_do"))
            G.GAME.hands[card.ability.to_do_poker_hand].visible = true
            return { message = localize("k_reset") }
        end
    end,
}
