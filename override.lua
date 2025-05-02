local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local retval = use_and_sell_buttonsref(card)
    if
        card.area
        and card.area.config.type == "joker"
        and card.ability.set == "Joker"
        and card.ability.folly_show_button
    then
        local use = {
            n = G.UIT.C,
            config = { h = 0.6, align = "cr" },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        ref_table = card,
                        align = "cr",
                        maxw = 1.25,
                        padding = 0.1,
                        r = 0.08,
                        minw = 1.25,
                        hover = true,
                        shadow = true,
                        colour = G.C.GOLD,
                        one_press = true,
                        button = "sell_card", -- will change when func is called
                        func = "folly_button_state",
                    },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "tm" },
                            nodes = {
                                { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                                {
                                    n = G.UIT.C,
                                    config = { align = "tm" },
                                    nodes = card.config.center:folly_button_nodes(card),
                                },
                            },
                        },
                    },
                },
            },
        }
        retval.nodes[1].nodes[2].nodes = retval.nodes[1].nodes[2].nodes or {}
        table.insert(retval.nodes[1].nodes[2].nodes, use)
    end
    return retval
end
G.FUNCS.folly_button_state = function(e)
    local card = e.config.ref_table
    if card.config.center:folly_can_use_button(card) then
        e.config.colour = G.C.GOLD
        e.config.button = "folly_button_use"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.folly_button_use = function(e)
    local card = e.config.ref_table
    card.config.center:folly_button_use(card)
end

function get_straight(hand, min_length, skip, wrap)
    local jimbos = {}
    for i, v in pairs(hand) do
        if SMODS.has_enhancement(v, 'm_folly_jimbo') then
            table.insert(jimbos, v)
        end
    end
    min_length = min_length or 5
    if min_length < 2 then min_length = 2 end
    if #hand < min_length then return {} end
    local ranks = {}
    for k,_ in pairs(SMODS.Ranks) do ranks[k] = {} end
    for _,card in ipairs(hand) do
        local id = card:get_id()
        if id > 0 then
            for k,v in pairs(SMODS.Ranks) do
                if v.id == id then table.insert(ranks[k], card); break end
            end
        end
    end
    local function next_ranks(key, start)
        local rank = SMODS.Ranks[key]
        local ret = {}
        if not start and not wrap and rank.straight_edge then return ret end
        for _,v in ipairs(rank.next) do
            ret[#ret+1] = v
            if skip and (wrap or not SMODS.Ranks[v].straight_edge) then
                for _,w in ipairs(SMODS.Ranks[v].next) do
                    ret[#ret+1] = w
                end
            end
        end
        return ret
    end
    local tuples = {}
    local ret = {}
    for _,k in ipairs(SMODS.Rank.obj_buffer) do
        if next(ranks[k]) then
            tuples[#tuples+1] = {key = {k}, jimbos = #jimbos}
        end
    end
    for i = 2, #hand+1 do
        local new_tuples = {}
        for _, tuple in ipairs(tuples) do
            local any_tuple
            if i ~= #hand+1 then
                for _,l in ipairs(next_ranks(tuple.key[i-1], i == 2)) do
                    if next(ranks[l]) then
                        local new_tuple = {key = {}, jimbo = 0}
                        for _,v in ipairs(tuple.key) do
                            new_tuple.key[#new_tuple.key+1] = v
                        end
                        new_tuple.key[#new_tuple.key+1] = l
                        new_tuple.jimbos = tuple.jimbos
                        new_tuples[#new_tuples+1] = new_tuple
                        any_tuple = true
                    end
                end
                if not any_tuple and tuple.jimbos > 0 then -- check if the we have a "jimbo token" in the tuple
                    local next = 0
                    local new_tuple = {key = {}, jimbo = 0}
                    for _,v in ipairs(tuple.key) do
                        new_tuple.key[#new_tuple.key+1] = v
                        if v == SMODS.Ranks[SMODS.Rank.max_id.value] then -- back track by 4 if we don't have a "next" value
                            next = SMODS.Ranks[SMODS.Rank.max_id.value - 4]
                        else
                            next = next_ranks(v)[1]
                        end
                    end
                    new_tuple.key[#new_tuple.key+1] = next
                    new_tuple.jimbos = tuple.jimbos - 1
                    new_tuples[#new_tuples+1] = new_tuple
                    any_tuple = true
                end
            end
            if i > min_length and not any_tuple then
                local straight = {}
                for _,v in ipairs(tuple.key) do
                    for _,card in ipairs(ranks[v]) do
                        straight[#straight+1] = card
                    end
                end
                for j = 1, #jimbos do -- fill the empty slots with the jimbos we added
                    straight[#straight+1] = jimbos[j]
                end
                ret[#ret+1] = straight
            end
        end
        tuples = new_tuples
    end
    table.sort(ret, function(a,b) return #a > #b end)
    return ret
end