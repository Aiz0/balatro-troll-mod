return {
    misc = {
        dictionary = {
            k_folly_shoot_the_moon = "Shoot the moon!",
            k_folly_mega_jackpot = "Mega Jackpot!",
            k_folly_masion = "Evil Billionaire Power",
            k_folly_cavendish = "Rotten!",
            k_folly_dr_house = "This Vexes Me",
        },
    },
    descriptions = {
        Joker = {
            j_folly_campfire = {
                name = "Campfire",
                text = {
                    "This Joker gains {X:mult,C:white}X#1#{} Mult for",
                    "each card sold and loses {X:mult,C:white}X#1#{} Mult",
                    "for each hand played",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                }
            },
            j_folly_charcoal = {
                name = "Charcoal",
                text = {
                    "You have to keep your",
                    "campfire lit, idiot",
                    "{C:mult}#1#{} Mult",
                    "Costs {C:money}$5{} to sell",
                    "because of carbon tax"
                }
            },
            j_folly_apartment = {
                name = "Apartment",
                text = {
                    "This Joker gains",
                    "Chips equal to the",
                    "{C:attention}lowest{} ranked card",
                    "held in hand",
                    "{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips)"
                }
            },
            j_folly_house = {
                name = "House",
                text = {
                    "Every played {C:attention}card{}",
                    "permanently gains",
                    "{C:mult}+1{} Mult when scored",
                }
            },
            j_folly_mansion = {
                name = "Mansion",
                text = {
                    "Reduces rank of",
                    "all {C:attention}scoring cards{}",
                    "in played hand",
                    "Gain {X:red,C:white}X#1#{} Mult",
                    "per rank reduced",
                    "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult)"
                }
            },
            j_folly_dr_house = {
                name = "Dr. House",
                text = {
                    "{C:inactive}Debuffed {}cards still score.",
                    "{C:inactive}Debuffed{} cards",
                    "each give {X:mult,C:white}X#1#{} Mult",
                    "{C:dark_edition}But watch out!"
                }
            },
        }
    }
}
