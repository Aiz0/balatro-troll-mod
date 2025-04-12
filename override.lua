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
