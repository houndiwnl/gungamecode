using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
gungame := class(creative_device):

    var PlayerMap : [player]int = map {}
    
    @editable
    var WeaponGranters : []item_granter_device = array{}

    @editable
    var EndGameDevice : end_game_device = end_game_device{}

    var ElimsToEndGame : int = 0

    @editable 
    var Sentries : []sentry_device = array{}

        
    OnBegin<override>()<suspends>:void=
        set ElimsToEndGame = WeaponGranters.Length;
        InitPlayers()
        InitTestMode()
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
        
    InitPlayers() : void= 
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers, FortCharacter := Player.GetFortCharacter[]):
            if (set PlayerMap[Player] = 0, WeaponTier := PlayerMap[Player]):
                FortCharacter.EliminatedEvent().Subscribe(OnPlayerEliminated)
                GrantWeapon(Player, WeaponTier)   
    
    OnPlayerAdded(Player:player):void=
        if:
            FortCharacter := Player.GetFortCharacter[]
            set PlayerMap[Player] = 0
            WeaponTier := PlayerMap[Player]
        then:
            FortCharacter.EliminatedEvent().Subscribe(OnPlayerEliminated)
            GrantWeapon(Player, WeaponTier)

    GrantWeapon(Player : player, WeaponTier : int) : void=
        if (ItemGranter := WeaponGranters[WeaponTier]):
            ItemGranter.GrantItem(Player)

    OnPlayerEliminated(Result : elimination_result): void=
        Eliminator := Result.EliminatingCharacter
        if (FortCharacter := Eliminator?, EliminatingAgent := FortCharacter.GetAgent[]):

    PromotePlayer(Agent : agent) : void=
        var WeaponTier : int = 0
        if (Player := player[Agent], PlayerWeaponTier := PlayerMap[Player]):
            set WeaponTier = PlayerWeaponTier + 1
            CheckEndGame(Agent, WeaponTier)
    
        if (Player := player[Agent], set PlayerMap[Player] = WeaponTier):
            GrantWeapon(Player, WeaponTier)
    
        
    InitTestMode() : void=
        for (Sentry : Sentries):
            Sentry.EliminatedEvent.Subscribe(TestPlayerElimination)
        
    TestPlayerElimination(Agent : ?agent) : void=
       if (Player := Agent?):
            PromotePlayer(Player)
    
    
    CheckEndGame(Player : agent, WeaponTier : int) : void=
        if (WeaponTier >= ElimsToEndGame):
            EndGameDevice.Activate(Player)
    