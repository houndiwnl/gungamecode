using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using {/Verse.org/Assets}
using {/Fortnite.com/Playspaces }
using { /Verse.org/Random }

# THIS CODE BELONGS TO TH0MASCLASSIC
# ANY UPDATES OR BUGS MUST BE REPORTED TO HIM
# DO NOT RESELL THIS CODE OR DMCA ACTIONS WILL HAPPEN

# Version 2.3
# 11/09/2024

var PlayersPersistence:weak_map(player,player_persistent_data)=map{}f

ConvertToText(Number : float): string =
    # Handle numbers less than 1,000
    if (Number < 1000.0) {
        if (NumberInt := Int[Number]) {
            return "{NumberInt}"
        }
        return ""
    }
    # Handle numbers between 1,000 and 10,000
    else if (Number < 10000.0) {
        Thousands := Number / 1000.0
        if (ThousandsToInt := Int[Thousands]) {
            if (ThousandsToInt * 1.0 = Thousands) {
                return "{ThousandsToInt}.0 K"
            }
            else {
                Remainder := Number - (ThousandsToInt * 1000.0)
                DecimalPart := Remainder / 100.0
                if (Decimal := Int[DecimalPart]) {
                    return "{ThousandsToInt}.{Decimal} K"
                }
            }
        }
    }
    # Handle numbers between 10,000 and 100,000
    else if (Number < 100000.0) {
        TensOfThousands := Number / 1000.0
        if (TensOfThousandsToInt := Int[TensOfThousands]) {
            if (TensOfThousandsToInt * 1.0 = TensOfThousands) {
                return "{TensOfThousandsToInt}.0 K"
            }
            else {
                Remainder := Number - (TensOfThousandsToInt * 1000.0)
                DecimalPart := Remainder / 100.0
                if (Decimal := Int[DecimalPart]) {
                    return "{TensOfThousandsToInt}.{Decimal} K"
                }
            }
        }
    }
    # Handle numbers between 100,000 and 1,000,000
    else if (Number < 1000000.0) {
        HundredsOfThousands := Number / 1000.0
        if (HundredsOfThousandsToInt := Int[HundredsOfThousands]) {
            if (HundredsOfThousandsToInt * 1.0 = HundredsOfThousands) {
                return "{HundredsOfThousandsToInt}.0 K"
            }
            else {
                Remainder := Number - (HundredsOfThousandsToInt * 1000.0)
                DecimalPart := Remainder / 10000.0
                if (Decimal := Int[DecimalPart]) {
                    return "{HundredsOfThousandsToInt}.{Decimal} K"
                }
            }
        }
    }
    # Handle numbers 1,000,000 and above
    else {
        Millions := Number / 1000000.0
        if (MillionsToInt := Int[Millions]) {
            if (MillionsToInt * 1.0 = Millions) {
                return "{MillionsToInt}.0 M"
            }
            else {
                Remainder := Number - (MillionsToInt * 1000000.0)
                DecimalPart := Remainder / 100000.0
                if (Decimal := Int[DecimalPart]) {
                    return "{MillionsToInt}.{Decimal} M"
                }
            }
        }
    }

    return ""


# function needed to reorder Leadeboard System
SortFunction(Element1: int, Element2: int): int =
    if (Element1 > Element2):
        1
    else if (Element1 < Element2):
        -1
    else:
        0

# Remove The Player from the Map after they left
RemoveKeyFromMap(ExampleMap:[player]verse_ui, ElementToRemove:player):[player]verse_ui=
    var NewMap:[player]verse_ui = map{}
    # Concatenate Keys from ExampleMap into NewMap, excluding ElementToRemove
    for (Key -> Value : ExampleMap, Key <> ElementToRemove):
        set NewMap = ConcatenateMaps(NewMap, map{Key => Value})
    return NewMap


(Input:[]t where t:type).QuickSort<public>(CompareFunction(Element1:t, Element2:t):int):[]t = 

    if (Input.Length <= 1):
        return Input

    var Less : []t = array {}
    var Equal : []t = array {}
    var Greater : []t = array {}

    if (Pivot := Input[Int[Input.Length * 0.5]]):
        for (Element : Input):
            Result := CompareFunction(Element, Pivot)
            ArrayElement := array { Element }
            if (Result < 0):
                set Less += ArrayElement
            else if (Result > 0):
                set Greater += ArrayElement
            else:
                set Equal += ArrayElement

    Less.QuickSort(CompareFunction) + Equal + Greater.QuickSort(CompareFunction)

player_persistent_data:=class<final><persistable>():
    Version:int=3
    PurchasedItems : int = 0
    TotalBuyableItems : int = 0
    
    # This is the idx Prop
    MoneyPropsMap : [int]logic = map{}
    ZombiePropsMap : [int]logic = map{}
    GemsPropsMap : [int]logic = map{}
    SparePropsMap : [int]logic = map{}
    RebirthPropsMap : [int]logic = map{}

    # Values PerSecond
    RebirthSec : int = 0
    MoneySec : int = 0
    ZombiesSec: int = 0
    GemsSec : int = 0
    SpareSec : int = 0

    # Currency To Save
    Rebirth : int = 0
    Money : int = 0
    Zombies : int = 0
    Gems : int = 0
    Spare : int = 0

    # Flag To Ignore Old Bases
    Ignore : logic = true


MakePlayerProfileData<constructor>(Src:player_persistent_data)<transacts>:=player_persistent_data:
    Version:=Src.Version
    PurchasedItems := Src.PurchasedItems
    TotalBuyableItems := Src.TotalBuyableItems
    MoneyPropsMap := Src.MoneyPropsMap
    ZombiePropsMap := Src.ZombiePropsMap
    RebirthPropsMap := Src.RebirthPropsMap

    # Values PerSecond
    RebirthSec := Src.RebirthSec
    MoneySec := Src.MoneySec
    ZombiesSec:= Src.ZombiesSec
    GemsSec := Src.GemsSec
    SpareSec := Src.SpareSec
    
    # Currency To Save
    Rebirth := Src.Rebirth
    Money := Src.Money
    Zombies := Src.Zombies
    Gems := Src.Gems
    Spare := Src.Spare

    Ignore := Src.Ignore


MakeMessageTycoon<localizes>(value:string) : message = "{value}"

MakeFloatWith2dec(Number : float): string =
    if (NumberInt := Int[Number]) {
        var DecimalPart : float = Number - (NumberInt * 1.0)
        var FirstDecimal : int = 0
        var SecondDecimal : int = 0
        
        var DecimalLoop : float = DecimalPart * 10.0
        if (FirstDecimalInt := Int[DecimalLoop]) {
            set FirstDecimal = FirstDecimalInt
           
            set DecimalPart = DecimalLoop - (FirstDecimal *1.0)
        }
        
        set DecimalLoop = DecimalPart * 10.0
        if (SecondDecimalInt := Int[DecimalLoop]) {
            set SecondDecimal = SecondDecimalInt
        }
        
        return "{NumberInt}.{FirstDecimal}{SecondDecimal}"
    }
    return ""




identify_event_Tycoon(t:type, payload:type) := class {
    Identifier : t
    CallBack : type{_(:t, :payload) : void}
    Event(P: payload) : void =
        CallBack(Identifier, P)
}

SleepAndEnable(Trigger : trigger_device)<suspends>:void=
    Sleep(0.5)
    Trigger.Enable()

StringCommas(S: string): string =
    var New : string = ""
    var Counter : int = 0
    for (Idx := 0..S.Length-1, Char := S[S.Length-Idx-1]):
        if (Counter = 3):
            set Counter = 0
            set New = Concatenate(",", New)
        set New = Concatenate(array{Char}, New)
        set Counter += 1
    New

(Listenable : listenable(?agent)).SubscribeMaybeAgent(OutputFunc : tuple(?agent, t)->void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_maybe_agent(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)
    
wrapper_maybe_agent(t : type) := class():
    ExtraData : t;
    OutputFunc : tuple(?agent, t) -> void
    InputFunc(Agent : ?agent):void = OutputFunc(Agent, ExtraData)

add_currency := class<concrete>():
    @editable Currency : add_currency_enum = add_currency_enum.None
    @editable Trigger: trigger_device = trigger_device{}
    @editable Maybe_damage_prop : prop_manipulator_device = prop_manipulator_device{} # For Hitable things
    @editable AmountToAdd: int = 0

    # This Variable is being Used to determine if the things where bough and if so then we
    # can use this to save Player Info
    var Bought : logic = false
   
prop_manager := class():
    var PropStates: [string]logic = map{}  
    
        AddProp(PropID: string): void =
            if (not PropStates[PropID]):
                Print("Adding new Prop")
                if(set PropStates[PropID] = false){}
            else:
                Print("Prop Already exist {PropID}")
    
        SetHidden(PropID: string, Hidden: logic): void =
            if(Hidden = true):
                Print("Setting {PropID} to True")
            if(set PropStates[PropID] = Hidden){}
    
        IsHidden(PropID: string): logic =
            if (HiddenState := PropStates[PropID]):
                return HiddenState
            return false



constructor_prop := class<concrete>():
    @editable Prop: creative_prop = creative_prop{}
    var IsHidden: logic = false

    var ID : string = ""

    # Generate a unique ID based on the prop's attributes
    GenerateID<public>(): string =
        Transform := Prop.GetTransform()
        return "{Transform.Translation.X}_{Transform.Translation.Y}_{Transform.Translation.Z}"
        

random_class := class<concrete>():
    @editable UsageTrigger : trigger_device = trigger_device{}
    @editable MinValue : int = 0
    @editable MaxValue : int = 50

advanced_class_info := class<concrete>():
    
    # If need To Link To other Info Devices
    @editable EnableTriggers: []trigger_device = array{}
    @editable DisableTriggers: []trigger_device = array{}
    # IF you want to give Currency More than 1 time
    @editable Only1Time: logic = false
    # use the button to give Random values to the class
    @editable RandomValues : random_class = random_class{}
    # Trigger that will do the same as standing on top of the Prop
    @editable BuyTrigger : trigger_device = trigger_device{}

add_currency_enum := enum:
    Rebirth
    Money
    Zombie
    Gem
    Spare
    None
buy_class := class<concrete>():
    Velocity: float = 1.0 # The velocity of the props showing

    @editable Cost: int = 0
    @editable BuyProp : constructor_prop = constructor_prop{}
    @editable Maybe_damage_prop : prop_manipulator_device = prop_manipulator_device{} # For Hitable things
    @editable DontRemove: logic = false # This Will not Remove the Currency but instead will only Check The price
    @editable SuccessTrigger: trigger_device = trigger_device{} # To link to other Devices if need
    @editable ValueToAdd: int = 0
    @editable ShowProps: []constructor_prop = array{}
    @editable HideProps: []constructor_prop = array{}
    @editable MoreInfo : advanced_class_info = advanced_class_info{}
    
    # This Variable is being Used to determine if the things where bough and if so then we
    # can use this to save Player Info
    var Bought : logic = false


base_class := class<concrete>():

    var Player : ?player = false
    var VerseUI_pointer : ?verse_ui = false
    var SAVE_TIME_CONST_DONT_CHANGE : int = 0

    var StopCurrencys : int = 0

    var BillboardMoney: int = 0

    var firstMoneyUsed : int = 0

    PropManager<public>: prop_manager = prop_manager{}

    @editable OnLeftTrigger : trigger_device = trigger_device{}
    @editable _100percTrigger : trigger_device = trigger_device{}
    @editable RebirthButton : button_device = button_device{}
    @editable FailMessage: hud_message_device = hud_message_device{}
    @editable F_MessageTime : float = 5.0
    @editable SucceedMessage: hud_message_device = hud_message_device{}
    @editable RebirthFailMessage : hud_message_device = hud_message_device{}

    # First Button To setup The base to a Player
    @editable InitButton : constructor_prop = constructor_prop{}

    # Currency 1 Setup
    @editable MoneyBuyTriggers: []buy_class = array{}
     
    # Currency 2 Setup
    @editable ZombieBuyTriggers: []buy_class = array{}
    
    # Currency 3 Setup
    @editable GemBuyTriggers: []buy_class = array{}
   
    # Currency 4 Setup
    @editable SparesBuyTriggers: []buy_class = array{}
    
    # Currency 5 Setup
    @editable RebirthBuyTriggers : []buy_class = array{}
    
    #@editable AddCurrencyPerSecond: []add_currency = array{}
    @editable AddCurrency: []add_currency = array{}
   
    var TotalBuyableItems : int = 0
    var PurchasedItems <public> : int = 0
    var isBeingUsed <public>: logic = false

    # Method to calculate the total number of buyable items
    CalculateTotalBuyableItems<public>():void=
        set TotalBuyableItems = MoneyBuyTriggers.Length + 
                               ZombieBuyTriggers.Length + 
                               GemBuyTriggers.Length + 
                               SparesBuyTriggers.Length 
                               

    # Function to calculate and display the progress percentage
    CalculateProgressPercentage<public>():float=
        if(TotalBuyableItems > 0):
            Percentage := (PurchasedItems * 100.0) / (TotalBuyableItems * 1.0)
            if(Percentage >= 100.0, InPlayer := Player?) then _100percTrigger.Trigger(InPlayer)
            return Percentage
        return 0.0

    
    
    CoolDown(Time : float)<suspends>:void=
        set isBeingUsed = true
        Sleep(Time)
        set isBeingUsed = false



    LoadBase(PersisData : player_persistent_data)<suspends>: void =
        if (ExistPlayer := Player?):
            RebirthButton.Disable()
            Print("Loading Player Data")
                # Iterate through the saved data and restore the purchases
                for (Idx -> Bought : PersisData.MoneyPropsMap, Bought = true, BuyTrigger := MoneyBuyTriggers[Idx]):
                    set BuyTrigger.Bought = true
                    set PurchasedItems += 1
                    block:
                        Transform := BuyTrigger.BuyProp.Prop.GetTransform()
                        BuyTrigger.BuyProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                        HiddenState := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                        if(HiddenState = false):
                            PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                    for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform() ):
                            Print("Loading Prop, Show")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= 5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = true):
                                Print("Showing Props, setting Hidden To false")
                                PropManager.SetHidden(ManagedProp.ID, false)
                            else:
                                Print("Prop should be with IsHidden = true")
                    for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop,Hide")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = false):
                                Print("Hiding Props")
                                PropManager.SetHidden(ManagedProp.ID, true)
                            else:
                                Print("Prop should be with IsHidden = false")
                        
                    for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                    for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {Trigger.Disable()}

                # Iterate through the saved data and restore the purchases
                for (Idx -> Bought : PersisData.ZombiePropsMap, Bought = true, BuyTrigger := ZombieBuyTriggers[Idx]):
                    set BuyTrigger.Bought = true
                    set PurchasedItems += 1
                    block:
                        Transform := BuyTrigger.BuyProp.Prop.GetTransform()
                        BuyTrigger.BuyProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                        HiddenState := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                        if(HiddenState = false):
                            PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                    for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop, Show")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= 5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = true):
                                Print("Showing Props, setting Hidden To false")
                                PropManager.SetHidden(ManagedProp.ID, false)
                            else:
                                Print("Prop should be with IsHidden = true")

                    for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop,Hide")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = false):
                                Print("Hiding Props")
                                PropManager.SetHidden(ManagedProp.ID, true)
                            else:
                                Print("Prop should be with IsHidden = false")

                    for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                    for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {Trigger.Disable()}


                # Iterate through the saved data and restore the purchases
                for (Idx -> Bought : PersisData.GemsPropsMap, Bought = true, BuyTrigger := GemBuyTriggers[Idx]):
                    set BuyTrigger.Bought = true
                    set PurchasedItems += 1
                    block:
                        Transform := BuyTrigger.BuyProp.Prop.GetTransform()
                        BuyTrigger.BuyProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                        HiddenState := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                        if(HiddenState = false):
                            PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)

                    for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop, Show")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= 5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = true):
                                Print("Showing Props, setting Hidden To false")
                                PropManager.SetHidden(ManagedProp.ID, false)
                            else:
                                Print("Prop should be with IsHidden = true")

                    for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop,Hide")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = false):
                                Print("Hiding Props")
                                PropManager.SetHidden(ManagedProp.ID, true)
                            else:
                                Print("Prop should be with IsHidden = false")

                    for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                    for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {Trigger.Disable()}



                # Iterate through the saved data and restore the purchases
                for (Idx -> Bought : PersisData.SparePropsMap, Bought = true, BuyTrigger := SparesBuyTriggers[Idx]):
                    set BuyTrigger.Bought = true
                    set PurchasedItems += 1
                    block:
                        Transform := BuyTrigger.BuyProp.Prop.GetTransform()
                        BuyTrigger.BuyProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                        HiddenState := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                        if(HiddenState = false):
                            PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)

                    for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop, Show")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= 5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = true):
                                Print("Showing Props, setting Hidden To false")
                                PropManager.SetHidden(ManagedProp.ID, false)
                            else:
                                Print("Prop should be with IsHidden = true")

                    for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop,Hide")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = false):
                                Print("Hiding Props")
                                PropManager.SetHidden(ManagedProp.ID, true)
                            else:
                                Print("Prop should be with IsHidden = false")

                    for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                    for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {Trigger.Disable()}


                # Iterate through the saved data and restore the purchases
                for (Idx -> Bought : PersisData.RebirthPropsMap, Bought = true, BuyTrigger := RebirthBuyTriggers[Idx]):
                    set BuyTrigger.Bought = true
                    set PurchasedItems += 1
                    block:
                        Transform := BuyTrigger.BuyProp.Prop.GetTransform()
                        BuyTrigger.BuyProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                        HiddenState := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                        if(HiddenState = false):
                            PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)

                    for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop, Show")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= 5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = true):
                                Print("Showing Props, setting Hidden To false")
                                PropManager.SetHidden(ManagedProp.ID, false)
                            else:
                                Print("Prop should be with IsHidden = true")

                    for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[],Transform := ManagedProp.Prop.GetTransform()):
                            Print("Loading Prop,Hide")
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z:= -5000.0},Transform.Rotation,0.1)
                            IsHidden := PropManager.IsHidden(ManagedProp.ID)
                            if(IsHidden = false):
                                Print("Hiding Props")
                                PropManager.SetHidden(ManagedProp.ID, true)
                            else:
                                Print("Prop should be with IsHidden = false")

                    for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                    for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {Trigger.Disable()}


                
                    
    SaveBase():void=
        if(ExistPlayer := Player?):
            Print("Player Is Saving")

            var TempMoneyMap : [int]logic = map {}
            var TempZombieMap : [int]logic = map{}
            var TempGemMap : [int]logic = map{}
            var TempSpareMap : [int]logic = map{}
            var TempRebirthMap : [int]logic = map{}

            var MoneyPerSec_save : int = 0
            var ZombiesPerSec_save : int = 0
            var GemPerSec_save : int = 0
            var SparePerSec_save : int = 0
            var RebirthPerSec_save : int = 0
            
            # loop Trought all the Base Props etc to check if they were bought
            # if they were bought then we will save by order (map (int)(creative prop array) for show and for hide)
            for(Idx -> MoneyStation : MoneyBuyTriggers, MoneyStation.Bought = true):
                set MoneyPerSec_save += MoneyStation.ValueToAdd
                if(set TempMoneyMap[Idx] = MoneyStation.Bought){}
            for(Idx -> ZombieStation : ZombieBuyTriggers,ZombieStation.Bought = true):
                set ZombiesPerSec_save += ZombieStation.ValueToAdd
                if(set TempZombieMap[Idx] = ZombieStation.Bought){}
            for(Idx -> GemStation : GemBuyTriggers,GemStation.Bought = true):
                set GemPerSec_save += GemStation.ValueToAdd
                if(set TempGemMap[Idx] = GemStation.Bought){}
            for(Idx -> SpareStation : SparesBuyTriggers,SpareStation.Bought = true):
                set SparePerSec_save += SpareStation.ValueToAdd
                if(set TempSpareMap[Idx] = SpareStation.Bought){}
            for(Idx -> RebirthStation : RebirthBuyTriggers,RebirthStation.Bought = true):
                set RebirthPerSec_save += RebirthStation.ValueToAdd
                if(set TempRebirthMap[Idx] = RebirthStation.Bought){}

            if :
                PersisData := PlayersPersistence[ExistPlayer]
                set PlayersPersistence[ExistPlayer]=player_persistent_data:
                    MakePlayerProfileData<constructor>(PersisData)
                    MoneyPropsMap := TempMoneyMap
                    ZombiePropsMap := TempZombieMap
                    GemsPropsMap :=  TempGemMap
                    SparePropsMap := TempSpareMap
                    RebirthPropsMap := TempRebirthMap
                    RebirthSec := RebirthPerSec_save
                    MoneySec := MoneyPerSec_save
                    ZombiesSec:=ZombiesPerSec_save
                    GemsSec :=GemPerSec_save
                    SpareSec :=SparePerSec_save
                    Ignore := false
            then:
                Print("Saved Player Data, Updated Data")
            else:
                if:
                    set PlayersPersistence[ExistPlayer]=player_persistent_data{
                        MoneyPropsMap := TempMoneyMap
                        ZombiePropsMap := TempZombieMap
                        GemsPropsMap :=  TempGemMap
                        SparePropsMap := TempSpareMap
                        RebirthPropsMap := TempRebirthMap
                        RebirthSec := RebirthPerSec_save
                        MoneySec := MoneyPerSec_save
                        ZombiesSec:=ZombiesPerSec_save
                        GemsSec :=GemPerSec_save
                        SpareSec :=SparePerSec_save
                        Ignore := false
                    }
                then:
                    Print("Creating new Verse Persistence, saving Data")

        
    StartSave()<suspends>:void=
        # 45 Minutes timer
        var minutes : int = SAVE_TIME_CONST_DONT_CHANGE
        
        loop:
            # if Flag is set to 1 then stop the loop
            # When a player left for exemple to avoid
            # unecessary threads
            if(StopCurrencys = 1) then return
            Sleep(1.0)
            set minutes -= 1
            Print("Left Time To Save {minutes} Seconds")
            if(minutes <= 0):
                if(VerseUI := VerseUI_pointer?):
                    SaveBase()
                    spawn{VerseUI.SaveCurrency()} 
                set minutes = SAVE_TIME_CONST_DONT_CHANGE
        
    
    # Function to assign IDs for a list of props
    AssignIDsForProps<public>(Props: []constructor_prop): void =
        for (ManagedProp: Props):
            ID := ManagedProp.GenerateID()
            HiddenState := PropManager.IsHidden(ID)
            if (HiddenState = false):
                PropManager.AddProp(ID)
                set ManagedProp.ID = "{ID}"

    AssignIds<public>():void=
        ID := InitButton.GenerateID()
            HiddenState := PropManager.IsHidden(ID)
            if (HiddenState = false):
                PropManager.AddProp(ID)
                set InitButton.ID = "{ID}"
        
        
        for (BuyTrigger: MoneyBuyTriggers):
            AssignIDsForProp(BuyTrigger.BuyProp)
            AssignIDsForProps(BuyTrigger.ShowProps)
            AssignIDsForProps(BuyTrigger.HideProps)

        for (BuyTrigger: ZombieBuyTriggers):
            AssignIDsForProp(BuyTrigger.BuyProp)
            AssignIDsForProps(BuyTrigger.ShowProps)
            AssignIDsForProps(BuyTrigger.HideProps)

        for (BuyTrigger: GemBuyTriggers):
            AssignIDsForProp(BuyTrigger.BuyProp)
            AssignIDsForProps(BuyTrigger.ShowProps)
            AssignIDsForProps(BuyTrigger.HideProps)

        for (BuyTrigger: SparesBuyTriggers):
            AssignIDsForProp(BuyTrigger.BuyProp)
            AssignIDsForProps(BuyTrigger.ShowProps)
            AssignIDsForProps(BuyTrigger.HideProps)

        for (BuyTrigger: RebirthBuyTriggers):
            AssignIDsForProp(BuyTrigger.BuyProp)
            AssignIDsForProps(BuyTrigger.ShowProps)
            AssignIDsForProps(BuyTrigger.HideProps)

        
    AssignIDsForProp(ManagedProp : constructor_prop):void=
        ID := ManagedProp.GenerateID()
        HiddenState := PropManager.IsHidden(ID)
        if (HiddenState = false):
            PropManager.AddProp(ID)
            set ManagedProp.ID = "{ID}"


ScoreValueName: string = ()

verse_ui := class() {
    OurPlayerUI: player_ui
    OurPlayer: player
    SAVE_TIME_CONST_DONT_CHANGE : int

    ShowMoney : logic
    ShowSubs : logic
    ShowGem : logic
    ShowSpare : logic
    ShowRebirth : logic
    UseMultiplier : logic
    
    var <public>Score : int = 0
    var Money: float = 0.0
    var MoneyPerSecond: int = 0
    var Zombie: float = 0.0
    var ZombiePerSecond: int = 0
    var Gem : float = 0.0
    var GemPerSecond : int = 0
    var Spares : float = 0.0
    var SparesPerSecond : int = 0
    var <public>Rebirth : int = 0
   

    var Canvas : ?canvas = false
    var MoneyText : text_block = text_block{DefaultTextColor := NamedColors.White,DefaultJustification := text_justification.Left, DefaultShadowOffset:= option{vector2{X:=2.0, Y:=2.0}},DefaultShadowColor := color{R:=0.0, G:=0.0, B:=0.0},DefaultTextOpacity := (1.0)}
    var MoneyPerSecondText : text_block = text_block{DefaultTextColor := NamedColors.White}

    var ZombieText : text_block = text_block{DefaultTextColor := NamedColors.White,DefaultJustification := text_justification.Left,DefaultShadowOffset:= option{vector2{X:=2.0, Y:=2.0}},DefaultShadowColor := color{R:=0.0, G:=0.0, B:=0.0},DefaultTextOpacity := (1.0)}
    var ZombiePerSecondText : text_block = text_block{DefaultTextColor := NamedColors.White}

    var GemText : text_block = text_block{DefaultTextColor := NamedColors.White,DefaultJustification := text_justification.Left,DefaultShadowOffset:= option{vector2{X:=2.0, Y:=2.0}},DefaultShadowColor := color{R:=0.0, G:=0.0, B:=0.0},DefaultTextOpacity := (1.0)}
    var GemPerSecondText : text_block = text_block{DefaultTextColor := NamedColors.White}

    var SparesText : text_block = text_block{DefaultTextColor := NamedColors.Aqua,DefaultJustification := text_justification.Left,DefaultShadowOffset:= option{vector2{X:=2.0, Y:=2.0}},DefaultShadowColor := color{R:=0.0, G:=0.0, B:=0.0},DefaultTextOpacity := (1.0)}
    var SparesPerSecondText : text_block = text_block{DefaultTextColor := NamedColors.White}

    var RebirthText : text_block = text_block{DefaultTextColor := NamedColors.White,DefaultJustification := text_justification.Left,DefaultShadowOffset:= option{vector2{X:=2.0, Y:=2.0}},DefaultShadowColor := color{R:=0.0, G:=0.0, B:=0.0},DefaultTextOpacity := (1.0)}

    var Percentage<public> : int = 0
    var PercentageText : text_block = text_block{DefaultTextColor := NamedColors.White,DefaultJustification := text_justification.Left, DefaultShadowOffset:= option{vector2{X:=0.0, Y:=0.0}},DefaultShadowColor := color{R:=0.0, G:=0.0, B:=0.0},DefaultTextOpacity := (1.0)}
    
    var Multiplier : float = 1.0
    var MultiplierText : text_block = text_block{DefaultTextColor := NamedColors.White,DefaultJustification := text_justification.Left, DefaultShadowOffset:= option{vector2{X:=0.0, Y:=0.0}},DefaultShadowColor := color{R:=0.0, G:=0.0, B:=0.0},DefaultTextOpacity := (1.0)}

    var SaveTime : int = 0
    var SaveText : text_block := text_block{DefaultTextColor := NamedColors.White,DefaultJustification := text_justification.Left, DefaultShadowOffset:= option{vector2{X:=0.0, Y:=0.0}},DefaultShadowColor := color{R:=0.0, G:=0.0, B:=0.0},DefaultTextOpacity := (1.0)}
        
    
    # CurrId corresponds to the Rebirth,Money etc in this order
    # Price is the BuyTrigger Cost
    # Calculates the diff between VERSE UI CURRENCY AND THE BUYTRIGGER Cost
    # RETURNS THAT DIFF
    CalculatePrice(CurrId : int,Price : int):string=
        if(CurrId = 0):
            return ConvertToText((Price - Rebirth )* 1.0)
        if(CurrId = 1):
            return ConvertToText((Price * 1.0) - Money)
        if(CurrId = 2):
            return ConvertToText((Price * 1.0) - Zombie)
        if(CurrId = 3):
            return ConvertToText((Price * 1.0) - Gem)
        if(CurrId = 4):
            return ConvertToText((Price * 1.0) - Spares)
        return "0.0"

    SaveCurrency()<suspends>:void=
        if:
            Data := PlayersPersistence[OurPlayer]
            MoneyInt := Int[Money]
            ZombieInt := Int[Zombie]
            GemInt := Int[Gem]
            SpareInt := Int[Spares]
            set PlayersPersistence[OurPlayer]=player_persistent_data:
                MakePlayerProfileData<constructor>(Data)
                Rebirth := Rebirth
                Money := MoneyInt
                Zombies := ZombieInt
                Gems := GemInt
                Spare := SpareInt
        then:
            Print("Saved Player Persistence VERSE_UI CURRENCY")

    LoadCurrency()<suspends>:void=
        if:
            Data := PlayersPersistence[OurPlayer]
            Data.Ignore = false
    
        then:
            set Rebirth = Data.Rebirth
            set Money = Data.Money * 1.0
            set Zombie = Data.Zombies  * 1.0
            set Gem = Data.Gems  * 1.0
            set Spares = Data.Spare  * 1.0

    # Reset Currency, this is good when using rebirth and reset triggers
    # it also stop any current loop
    ResetCurrencys()<suspends>:void=
        set Money = 0.0
        set MoneyPerSecond = 0

        set Zombie = 0.0
        set ZombiePerSecond = 0

        set Gem = 0.0
        set GemPerSecond = 0

        set Spares = 0.0
        set SparesPerSecond = 0

        set Percentage = 0
        
        if(ShowMoney = true):
            MoneyText.SetText(MakeMessageTycoon("{Money}"))
            MoneyPerSecondText.SetText(MakeMessageTycoon("{MoneyPerSecond}"))


        if(ShowSubs = true):
            ZombieText.SetText(MakeMessageTycoon("{Zombie}"))
            ZombiePerSecondText.SetText(MakeMessageTycoon("{ZombiePerSecond}"))

        if(ShowGem = true):
            GemText.SetText(MakeMessageTycoon("{Gem}"))
            GemPerSecondText.SetText(MakeMessageTycoon("{GemPerSecond}"))
            
        if(ShowSpare = true):
            SparesText.SetText(MakeMessageTycoon("{Spares}"))
            SparesPerSecondText.SetText(MakeMessageTycoon("{SparesPerSecond}"))

        if(ShowRebirth = true):
            PercentageText.SetText(MakeMessageTycoon("{Percentage}"))
            var  multiplierTemp : float = Multiplier
            if(Rebirth = 0):
                set multiplierTemp = 1.0
            MultiplierText.SetText(MakeMessageTycoon("{MakeFloatWith2dec(multiplierTemp)}x"))   
             
    InitWidget(RebirthValue : int) : void =

        set Rebirth = RebirthValue
        if(UseMultiplier = true and Rebirth <> 0) then set Multiplier = Rebirth * Multiplier
        
        MoneyText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        MoneyText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        MoneyText.SetShadowOpacity(0.0)

        ZombieText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        ZombieText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        ZombieText.SetShadowOpacity(0.0)
        ZombiePerSecondText.SetShadowOpacity(0.0)
        ZombiePerSecondText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        ZombiePerSecondText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})

        GemText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        GemText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        GemText.SetShadowOpacity(0.0)

        SparesText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        SparesText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        SparesText.SetShadowOpacity(0.0)

        RebirthText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        RebirthText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        RebirthText.SetShadowOpacity(0.0)

        SaveText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        SaveText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        SaveText.SetShadowOpacity(0.0)

        MoneyText.SetText(MakeMessageTycoon(""))
        MoneyPerSecondText.SetText(MakeMessageTycoon("Money/S: 0 $"))
        ZombieText.SetText(MakeMessageTycoon(""))
        ZombiePerSecondText.SetText(MakeMessageTycoon("Spares/S: 0"))
        GemText.SetText(MakeMessageTycoon(""))
        GemPerSecondText.SetText(MakeMessageTycoon("Gem/S: 0"))
        SparesPerSecondText.SetText(MakeMessageTycoon("Hacked/S: 0"))
        

        NewUI := CreateUI()
        OurPlayerUI.AddWidget(NewUI, player_ui_slot{InputMode := ui_input_mode.None})
        set Canvas = option{NewUI}
        spawn{HandleUISave()}

    HandleUISave()<suspends>:void=
        Print("UI Save Loop started")
        loop:
            Sleep(1.0)
            set SaveTime -= 1
            if(SaveTime <= 0) then set SaveTime = SAVE_TIME_CONST_DONT_CHANGE
            str := TimeToMinSecFormat(SaveTime)
            SaveText.SetText(MakeMessageTycoon(str))


            
    TimeToMinSecFormat(TimeInSec: int): string =
        Minutes := TimeInSec * 1.0 / ( 60 * 1.0 )         # Get the number of minutes
        if:
            MinutesInt := Int[Minutes]
            SecondsInt := Mod[TimeInSec, 60]  # Calculate the remaining seconds
        then:
            if(SecondsInt < 10):
                # Format the time as "min:sec", ensuring seconds always have two digits
                return "{MinutesInt}:0{SecondsInt}"
            else:

                return "{MinutesInt}:{SecondsInt}"
        else:
            return ""
       

    RemoveUI():void=
        if(NewUI := Canvas?):
            OurPlayerUI.RemoveWidget(NewUI)

    UpdateBasePercentage(SetAmount : int):void=
        set Percentage = SetAmount
        PercentageText.SetText(MakeMessageTycoon("{Percentage}%"))
        PercentageText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        PercentageText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        PercentageText.SetShadowOpacity(0.0)

    UpdateMoney(Amount: float): void =
        Print("Amount is {Amount}")
        set Money += Amount
        MoneyText.SetText(MakeMessageTycoon("  {ConvertToText(Money * 1.0)}                  "))  
        MoneyText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        MoneyText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        MoneyText.SetShadowOpacity(0.0)

    UpdateZombie(Amount: float): void =
        set Zombie += Amount
        ZombieText.SetText(MakeMessageTycoon("  {ConvertToText(Zombie * 1.0)}                  "))
        ZombieText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        ZombieText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        ZombieText.SetShadowOpacity(0.0)

    UpdateMoneyPerSecond(Amount: int, Billboard: billboard_device): void =
        set MoneyPerSecond += Amount
        MoneyPerSecondString := StringCommas("{MoneyPerSecond}")
        MoneyPerSecondText.SetText(MakeMessageTycoon("Money/S: {ConvertToText(MoneyPerSecond * 1.0)} $"))
        
    UpdateZombiePerSecond(Amount: int): void =
        set ZombiePerSecond += Amount
        ZombiePerSecondString := StringCommas("{ZombiePerSecond}")
        ZombiePerSecondText.SetText(MakeMessageTycoon("{ZombiePerSecondString}"))

    UpdateGem(Amount:float):void=
        set Gem += Amount
        GemString :=  StringCommas("{Gem}")
        GemText.SetText(MakeMessageTycoon("  {ConvertToText(Gem * 1.0)}                  "))
        GemText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        GemText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        GemText.SetShadowOpacity(0.0)
    UpdateGemPerSecond(Amount:int):void=
        set GemPerSecond += Amount
        GemPerSecondString := StringCommas("{GemPerSecond}")
        GemPerSecondText.SetText(MakeMessageTycoon("{GemPerSecondString}"))
    UpdateSpares(Amount:float):void=
        set Spares += Amount
        SpareString := StringCommas("{Spares}")
        SparesText.SetText(MakeMessageTycoon("  {ConvertToText(Spares * 1.0)}                  "))
        SparesText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        SparesText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        SparesText.SetShadowOpacity(0.0)
    UpdateSparesPerSecond(Amount:int):void=
        set SparesPerSecond += Amount
        SparePerSecondString := StringCommas("{SparesPerSecond}")
        SparesPerSecondText.SetText(MakeMessageTycoon("{SparePerSecondString}"))
    UpdateRebirth(Amount : int):logic=
        set Rebirth += Amount
        RebirthString :=  StringCommas("{Rebirth}")
        RebirthText.SetText(MakeMessageTycoon("  {RebirthString}"))
        RebirthText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
        RebirthText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
        RebirthText.SetShadowOpacity(0.0)
        return true

    CreateUI() : canvas =

        var MoneyOverlay : texture_block = texture_block{DefaultImage:= Images.Blank}
        var SubsOverlay : texture_block = texture_block{DefaultImage:= Images.Blank}
        var GemOverlay : texture_block = texture_block{DefaultImage:= Images.Blank}
        var SpareOverlay : texture_block = texture_block{DefaultImage:= Images.Blank}
        var RebirthOverlay : texture_block = texture_block{DefaultImage:= Images.Blank}

        var MoneyWidget : texture_block = texture_block{DefaultImage:= Images.Blank}
        var GemWidget : texture_block = texture_block{DefaultImage:= Images.Blank}
        var SubsWidget : texture_block = texture_block{DefaultImage:= Images.Blank}
        var SpareWidget : texture_block = texture_block{DefaultImage:= Images.Blank}
        var RebirthWidget : texture_block = texture_block{DefaultImage:= Images.Blank}
        
        var SaveImage : texture_block = texture_block{DefaultImage := Images.AutoSaveGreenUI, DefaultDesiredSize := vector2{X:= 340.0,Y:=100.0}}
        
        if(ShowMoney = true):
            

            MoneyText.SetText(MakeMessageTycoon("  {ConvertToText(Money * 1.0)}                  "))

            set MoneyWidget = texture_block{
                DefaultImage:=Images.MoneyUI
                DefaultDesiredSize := vector2{X := 300.0, Y :=60.0}
            }
        if(ShowSubs = true):
          
            ZombieText.SetText(MakeMessageTycoon("  {ConvertToText(Zombie * 1.0)}                  "))

            set SubsWidget = texture_block{
                DefaultImage:=Images.SoldierUI
                DefaultDesiredSize := vector2{X := 300.0, Y :=60.0}
            }

        if(ShowGem = true):
           

            set GemWidget = texture_block{
                DefaultImage:=Images.DiamondUI
                DefaultDesiredSize := vector2{X := 300.0, Y :=60.0}
            }

            GemText.SetText(MakeMessageTycoon("  {ConvertToText(Gem * 1.0)}                  "))
        if(ShowSpare = true):
           
            set SpareWidget = texture_block{
                DefaultImage:=Images.GEMUI
                DefaultDesiredSize := vector2{X := 300.0, Y :=60.0}
            }

            SparesText.SetText(MakeMessageTycoon("  {ConvertToText(Spares * 1.0)}                  "))
        if(ShowRebirth = true):
           

            set RebirthWidget = texture_block{
                DefaultImage:=Images.RebirthPercentageUI
                DefaultDesiredSize := vector2{X := 300.0, Y :=100.0}
            }

            RebirthText.SetText(MakeMessageTycoon("  {ConvertToText(Rebirth * 1.0)}"))

            PercentageText.SetText(MakeMessageTycoon("{Percentage}%"))   
            PercentageText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
            PercentageText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
            PercentageText.SetShadowOpacity(0.0) 
            
            var  multiplierTemp : float = Multiplier
            if(Rebirth = 0):
                set multiplierTemp = 1.0
            MultiplierText.SetText(MakeMessageTycoon("{MakeFloatWith2dec(multiplierTemp)}x"))     
            MultiplierText.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
            MultiplierText.SetShadowOffset(option{vector2{X:=0.0, Y:=0.0}})
            MultiplierText.SetShadowOpacity(0.0)       
            
        MyCanvas := canvas:
            Slots:=array:
                #Canvas
                canvas_slot:
                    Anchors:=anchors{Minimum:=vector2{X:=1.0,Y:=0.0},Maximum:=vector2{X:=1.0,Y:=0.0}}
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                Widget:=overlay:
                                            Slots := array:
                                                overlay_slot:
                                                    Widget := SaveImage
                                                    Padding := margin{Left := -360.0, Top := 350.0}
                                                    HorizontalAlignment:=horizontal_alignment.Left
                                                overlay_slot: 
                                                    Widget:=SaveText
                                                    Padding := margin{Left := -180.0, Top := 365.0}
                                                    HorizontalAlignment:=horizontal_alignment.Left
                                                
                                HorizontalAlignment:=horizontal_alignment.Left
                                VerticalAlignment:=vertical_alignment.Top
                                
                canvas_slot:
                    Anchors:=anchors{Minimum:=vector2{X:=0.000000,Y:=0.45},Maximum:=vector2{X:=0.000000,Y:=0.45}}
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                Widget:=overlay:
                                            Slots := array:
                                                overlay_slot:
                                                    Widget := RebirthWidget
                                                    Padding := margin{Left := 18.0}
                                                    HorizontalAlignment:=horizontal_alignment.Left
                                                overlay_slot: 
                                                    Widget:=RebirthText
                                                    Padding := margin{Left := 100.0,Bottom := 10.0}
                                                    HorizontalAlignment:=horizontal_alignment.Left
                                                overlay_slot: 
                                                    Widget:=PercentageText
                                                    Padding := margin{Left := 80.0,Bottom := 10.0}
                                                    HorizontalAlignment:=horizontal_alignment.Center
                                                overlay_slot: 
                                                    Widget:=MultiplierText
                                                    Padding := margin{Left := 10.0,Top := 30.0}
                                                    HorizontalAlignment:=horizontal_alignment.Center

                                HorizontalAlignment:=horizontal_alignment.Left
                                VerticalAlignment:=vertical_alignment.Top
                                
                            overlay_slot:
                                Widget:=overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := MoneyWidget
                                            Padding := margin{Left := 18.0}
                                            HorizontalAlignment:=horizontal_alignment.Left
                                        overlay_slot: 
                                            Widget:=MoneyText
                                            Padding := margin{Left := 80.0}
                                            HorizontalAlignment:=horizontal_alignment.Left
                                HorizontalAlignment:=horizontal_alignment.Left
                                VerticalAlignment:=vertical_alignment.Top
                                Padding := margin{Top := 65.0 + 40.0}

                            overlay_slot:
                                Widget:=overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := SubsWidget
                                            Padding := margin{Left := 18.0}
                                            HorizontalAlignment:=horizontal_alignment.Left
                                        overlay_slot: 
                                            Widget:=ZombieText
                                            Padding := margin{Left := 80.0} 
                                            HorizontalAlignment:=horizontal_alignment.Left
                                HorizontalAlignment:=horizontal_alignment.Left
                                VerticalAlignment:=vertical_alignment.Top
                                Padding := margin{Top := 130.0+ 40.0}

                            overlay_slot:
                                Widget:=overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := GemWidget
                                            Padding := margin{Left := 18.0}
                                            HorizontalAlignment:=horizontal_alignment.Left
                                        overlay_slot: 
                                            Widget:=GemText
                                            Padding := margin{Left := 80.0}
                                            HorizontalAlignment:=horizontal_alignment.Left
                                HorizontalAlignment:=horizontal_alignment.Left
                                VerticalAlignment:=vertical_alignment.Top
                                Padding := margin{Top := 195.0 + 40.0}
                            overlay_slot:
                                Widget:=overlay:
                                    Slots := array:
                                        overlay_slot:
                                            Widget := SpareWidget
                                            Padding := margin{Left := 18.0}
                                            HorizontalAlignment:=horizontal_alignment.Left
                                        overlay_slot: 
                                            Widget:=SparesText
                                            Padding := margin{Left := 80.0}
                                            HorizontalAlignment:=horizontal_alignment.Left
                                HorizontalAlignment:=horizontal_alignment.Left
                                VerticalAlignment:=vertical_alignment.Top
                                Padding := margin{Top := 255.0 + 40.0}


        
    
}
# UI INTERFACE 
# Setup of how many currency do u wanna show by doing True or false

ui_interface := class<concrete>():
    @editable UseMultiplier : logic = true
    @editable ShowRebirth : logic = false
    @editable ShowMoney : logic = false
    @editable ShowSubs : logic = false
    @editable ShowGem : logic = false
    @editable ShowSpare : logic = false

Tycoon_Device := class(creative_device):
    @editable
    VFX : creative_prop_asset = DefaultCreativePropAsset
    @editable
    VFXLength : float = 2.0
    @editable
    HideLocation : float = 5000.0
    @editable
    SAVE_TIME_CONST_DONT_CHANGE : int = 45 * 60
    @editable
    Multiplier : float = 2.0
    @editable 
    TycoonBases: []base_class = array{} 
    @editable 
    LevelVerse : level_manager_device = level_manager_device{}
    @editable
    LevelPerPurchaseAmount : int = 100
    @editable 
    HUD_inter : ui_interface = ui_interface{}
    @editable 
    ResetTriggers : []trigger_device = array{}

    @editable LoadMessage : popup_dialog_device = popup_dialog_device{}
    
    # Verse UI (Includes the currency Amount, Save UI and Leaderboard UI)
    var PlayerMap : [player]verse_ui = map{}
    var LeaderBoardMap : [agent]canvas = map{}

    # This will say if a payer has a Base and his Index
    var TycoonBaseMap: [agent]?int = map{}

    # Threshold for being "on top" of the prop (adjust this as needed)
    Threshold : float= 14000.0
    
    # This functions animates the Prop in order to achieve the Correct Animation
    ShowAnimationProp(Prop : creative_prop, TotalTime : float)<suspends>:void=
        if(Prop.IsValid[]):
            Transform := Prop.GetTransform()
            Print("AnimationFunction, Prop is {Transform.Translation.Z}")
            StretchedScale := Transform.Scale + vector3{X:= Transform.Scale.X *(-0.45), Y:=Transform.Scale.Y *(-0.25), Z:=Transform.Scale.Z*(1.2)}
            
            # Calculate the intermediate transform
            var InitialTransform : transform = transform{
                Scale := StretchedScale, 
                Rotation := Transform.Rotation, 
                Translation := Transform.Translation + vector3{Z := HideLocation - 300.0}
            }
            
            # Calculate the final transform
            var SlowerTransform : transform = transform{
                Scale := StretchedScale, 
                Rotation := Transform.Rotation, 
                Translation := InitialTransform.Translation + vector3{Z := 300.0}
            }
            
            # Define the time proportions for the two segments
            var FastTime : float = TotalTime * 0.3
            var SlowTime : float = TotalTime * 0.5
            
            # Move quickly for the first 14800 units
            Prop.MoveTo(InitialTransform, FastTime)
        
            # Move slowly for the next 300 units
            Prop.MoveTo(SlowerTransform, TotalTime * 0.3)
            
            Final := Prop.GetTransform()

            var FinalTransform : transform = transform{
                Scale := Transform.Scale, 
                Rotation := Transform.Rotation, 
                Translation := Final.Translation
            }

            Prop.MoveTo(FinalTransform, TotalTime * 0.45)
    
    HideAnimationProp(Prop : creative_prop, TotalTime : float)<suspends>:void=
        if(Prop.IsValid[]):
            Transform := Prop.GetTransform()
            StretchedScale := Transform.Scale + vector3{X:= -0.4, Y:=-0.4, Z:=-0.4}
            
            # Calculate the intermediate transform
            var InitialTransform : transform = transform{
                Scale := StretchedScale, 
                Rotation := Transform.Rotation, 
                Translation := Transform.Translation
            }
            
            # Calculate the final transform
            var FinalTransform : transform = transform{
                Scale := Transform.Scale, 
                Rotation := Transform.Rotation, 
                Translation := InitialTransform.Translation + vector3{Z := -HideLocation}
            }
            
            # Define the time proportions for the two segments
            var FastTime : float = TotalTime 
            var SlowTime : float = TotalTime * 0.8
            
            # Move quickly for the first 14000 units
            Prop.MoveTo(InitialTransform, FastTime)
            
            # Slow down for the last 1000 units
            Prop.MoveTo(FinalTransform, SlowTime)
    
    HandleTycoonInit()<suspends>: void=
        loop:
            Sleep(0.1)
            for(Player : GetPlayspace().GetPlayers(),FortChar := Player.GetFortCharacter[], VerseUI := PlayerMap[Player] ):
                if (TycoonBaseMap[Player]?){} # do nothing
                else:
                    # Loop through all available bases to check if one is nearby and unclaimed
                    for ( idx -> Base: TycoonBases, Base.Player = false):
                        
                            BaseTransform := Base.InitButton.Prop.GetTransform().Translation  # Get base button's transform
                            PlayerTransform := FortChar.GetTransform().Translation  # Get player’s position
                            
                            # Calculate distance between the player and the base button
                            DeltaX := BaseTransform.X - PlayerTransform.X
                            DeltaY := BaseTransform.Y - PlayerTransform.Y
                            DeltaZ := BaseTransform.Z - PlayerTransform.Z
                            SquaredDistance := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ

                            if (SquaredDistance <= Threshold):
                                #Print("Player is close enough to claim the base.")
                                if (set TycoonBaseMap[Player] = option{idx}):
                                #    Print("Player is Claiming the Base")
                                #    Print("Updating Base to have the new Player...")
                                    # Update Flags of the base to prevent Errors
                                    set Base.Player = option{Player}
                                    set Base.StopCurrencys = 0
                                    set Base.firstMoneyUsed = 0
                                    set Base.PurchasedItems = 0
                                    set Base.VerseUI_pointer = option{VerseUI}

                                    # Show the First Button To be able to claim again
                                    ManagedProp := Base.InitButton
                                    IsHidden := Base.PropManager.IsHidden(ManagedProp.ID)
                                    Transform := ManagedProp.Prop.GetTransform()
                                    if (IsHidden = false):
                                            spawn{HideAnimationProp(Base.InitButton.Prop,1.0)}
                                            Base.PropManager.SetHidden(ManagedProp.ID, true)
                                    else:
                                        Print("prop is already hidden")
                                    
                                    
                                    LevelVerse.AddUI(option{Player})
                                    # Starts and Shows the first Money
                                    UseMoney((idx,0),option{Player})

                                    

                            else:
                                #Print("No nearby base to claim. Base Idx = {idx}, Squaredistance = {SquaredDistance}")
                        


    OnBegin<override>()<suspends> : void =
            for (ResetTrigger : ResetTriggers):
                ResetTrigger.TriggeredEvent.Subscribe(ResetTycoon)
            for (InPlayer : GetPlayspace().GetPlayers()):
                HandlePlayerJoin(InPlayer)
            GetPlayspace().PlayerAddedEvent().Subscribe(HandlePlayerJoin)
            GetPlayspace().PlayerRemovedEvent().Subscribe(HandlePlayerLeft)
            LoadMessage.RespondingButtonEvent.Subscribe(OnLoadAnswered)
            spawn{HandleTycoonInit()}
            for (BaseIdx -> TycoonBase: TycoonBases):
                set TycoonBase.SAVE_TIME_CONST_DONT_CHANGE = SAVE_TIME_CONST_DONT_CHANGE
                TycoonBase.CalculateTotalBuyableItems()
                TycoonBase.AssignIds()
                HideAllProps(TycoonBase,TycoonBase.PropManager)
                for(AddCurrency : TycoonBase.AddCurrency):
                    if(AddCurrency.Currency = add_currency_enum.Money):
                        AddCurrency.Trigger.TriggeredEvent.SubscribeMaybeAgent(AddMoney, (AddCurrency.AmountToAdd))
                        EventIdentifier := identify_event_Tycoon(int,agent){Identifier := AddCurrency.AmountToAdd, CallBack := AddMoney2}
                        AddCurrency.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                    if(AddCurrency.Currency = add_currency_enum.Zombie):
                        AddCurrency.Trigger.TriggeredEvent.SubscribeMaybeAgent(AddZombie, (AddCurrency.AmountToAdd))
                        EventIdentifier := identify_event_Tycoon(int,agent){Identifier := AddCurrency.AmountToAdd, CallBack := AddZombie2}
                        AddCurrency.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                    if(AddCurrency.Currency = add_currency_enum.Gem):
                        AddCurrency.Trigger.TriggeredEvent.SubscribeMaybeAgent(AddGem, (AddCurrency.AmountToAdd))
                        EventIdentifier := identify_event_Tycoon(int,agent){Identifier := AddCurrency.AmountToAdd, CallBack := AddGem2}
                        AddCurrency.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                    if(AddCurrency.Currency = add_currency_enum.Spare):
                        AddCurrency.Trigger.TriggeredEvent.SubscribeMaybeAgent(AddSpare, (AddCurrency.AmountToAdd))
                        EventIdentifier := identify_event_Tycoon(int,agent){Identifier := AddCurrency.AmountToAdd, CallBack := AddSpare2}
                        AddCurrency.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                    if(AddCurrency.Currency = add_currency_enum.Rebirth):
                        AddCurrency.Trigger.TriggeredEvent.SubscribeMaybeAgent(AddRebirth, (AddCurrency.AmountToAdd))
                        EventIdentifier := identify_event_Tycoon(int,agent){Identifier := AddCurrency.AmountToAdd, CallBack := AddRebirth2}
                        AddCurrency.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                for (Idx -> BuyTrigger: TycoonBase.MoneyBuyTriggers):
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),agent){Identifier := (BaseIdx,Idx), CallBack := UseMoneyCraft}
                        BuyTrigger.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),?agent){Identifier := (BaseIdx,Idx), CallBack := UseMoney}
                        BuyTrigger.MoreInfo.BuyTrigger.TriggeredEvent.Subscribe(EventIdentifier.Event)
                   
                for (Idx -> BuyTrigger: TycoonBase.ZombieBuyTriggers):
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),agent){Identifier := (BaseIdx,Idx), CallBack := UseZombieCraft}
                        BuyTrigger.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),?agent){Identifier := (BaseIdx,Idx), CallBack := UseZombie}
                        BuyTrigger.MoreInfo.BuyTrigger.TriggeredEvent.Subscribe(EventIdentifier.Event)
                for (Idx -> BuyTrigger: TycoonBase.GemBuyTriggers):
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),agent){Identifier := (BaseIdx,Idx), CallBack := UseGemCraft}
                        BuyTrigger.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),?agent){Identifier := (BaseIdx,Idx), CallBack := UseGem}
                        BuyTrigger.MoreInfo.BuyTrigger.TriggeredEvent.Subscribe(EventIdentifier.Event)
                for (Idx -> BuyTrigger: TycoonBase.SparesBuyTriggers):
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),agent){Identifier := (BaseIdx,Idx), CallBack := UseSpareCraft}
                        BuyTrigger.Maybe_damage_prop.DamagedEvent.Subscribe(EventIdentifier.Event)
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),?agent){Identifier := (BaseIdx,Idx), CallBack := UseSpare}
                        BuyTrigger.MoreInfo.BuyTrigger.TriggeredEvent.Subscribe(EventIdentifier.Event)
                for (Idx -> BuyTrigger: TycoonBase.RebirthBuyTriggers):
                    block:
                        EventIdentifier := identify_event_Tycoon(tuple(int,int),?agent){Identifier := (BaseIdx,Idx), CallBack := UseRebirth}
                        BuyTrigger.MoreInfo.BuyTrigger.TriggeredEvent.Subscribe(EventIdentifier.Event)
                    
            spawn{MonitorTycoonBase()}
            
        

    # This will be the function checking the Buttons Position
    # performing Math calculations and then if so 
    # Calling other functions for the buy buttons
    MonitorTycoonBase()<suspends>:void=
        loop:
            Sleep(0.4)
            for(Player : GetPlayspace().GetPlayers()):
                CheckPlayerOnTopOfBuyProp(Player)
            

    # Check if a player is above a button and if so perform the Button Action
    CheckPlayerOnTopOfBuyProp(Player : player)<suspends>: void =
        if (BaseIdx := TycoonBaseMap[Player]?, TycoonBase := TycoonBases[BaseIdx],FortChar := Player.GetFortCharacter[]):
            
            PlayerTransform := FortChar.GetTransform().Translation

            # Loop through each buyable class and check if the player is close to the prop
            for (Idx -> BuyableClass : TycoonBase.MoneyBuyTriggers):

                # Get The Position of the Buy Prop
                PropTransform := BuyableClass.BuyProp.Prop.GetTransform().Translation

                # Calculate the distance between the player and the prop
                DeltaX := PropTransform.X - PlayerTransform.X
                DeltaY := PropTransform.Y - PlayerTransform.Y
                DeltaZ := PropTransform.Z - PlayerTransform.Z
                SquaredDistance := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ

                #Print("SquareDistance is {SquaredDistance}")

                if (SquaredDistance <= Threshold):
                    # Player is close enough to the prop, trigger the buy action
                    #Print("Player is close to the prop for BuyableClass Idx {Idx}, triggering UseMoney.")
                    UseMoney((BaseIdx,Idx),option{Player})
                else:
                    # Player is not close enough, do nothing or give feedback
                    #Print("Player is not close to the prop for BuyableClass Idx {Idx}.")

            # Loop through each buyable class and check if the player is close to the prop
            for (Idx -> BuyableClass : TycoonBase.ZombieBuyTriggers):

                # Get The Position of the Buy Prop
                PropTransform := BuyableClass.BuyProp.Prop.GetTransform().Translation

                # Calculate the distance between the player and the prop
                DeltaX := PropTransform.X - PlayerTransform.X
                DeltaY := PropTransform.Y - PlayerTransform.Y
                DeltaZ := PropTransform.Z - PlayerTransform.Z
                SquaredDistance := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ

                
                
                if (SquaredDistance <= Threshold):
                    # Player is close enough to the prop, trigger the buy action
                    #Print("Player is close to the prop for BuyableClass Idx {Idx}, triggering UseMoney.")
                    UseZombie((BaseIdx,Idx),option{Player})
                else:
                    # Player is not close enough, do nothing or give feedback
                    #Print("Player is not close to the prop for BuyableClass Idx {Idx}.")

            # Loop through each buyable class and check if the player is close to the prop
            for (Idx -> BuyableClass : TycoonBase.GemBuyTriggers):

                # Get The Position of the Buy Prop
                PropTransform := BuyableClass.BuyProp.Prop.GetTransform().Translation

                # Calculate the distance between the player and the prop
                DeltaX := PropTransform.X - PlayerTransform.X
                DeltaY := PropTransform.Y - PlayerTransform.Y
                DeltaZ := PropTransform.Z - PlayerTransform.Z
                SquaredDistance := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ

                
                
                if (SquaredDistance <= Threshold):
                    # Player is close enough to the prop, trigger the buy action
                    #Print("Player is close to the prop for BuyableClass Idx {Idx}, triggering UseMoney.")
                    UseGem((BaseIdx,Idx),option{Player})
                else:
                    # Player is not close enough, do nothing or give feedback
                    #Print("Player is not close to the prop for BuyableClass Idx {Idx}.")

            # Loop through each buyable class and check if the player is close to the prop
            for (Idx -> BuyableClass : TycoonBase.SparesBuyTriggers):

                # Get The Position of the Buy Prop
                PropTransform := BuyableClass.BuyProp.Prop.GetTransform().Translation

                # Calculate the distance between the player and the prop
                DeltaX := PropTransform.X - PlayerTransform.X
                DeltaY := PropTransform.Y - PlayerTransform.Y
                DeltaZ := PropTransform.Z - PlayerTransform.Z
                SquaredDistance := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ

                
                if (SquaredDistance <= Threshold):
                    # Player is close enough to the prop, trigger the buy action
                    #Print("Player is close to the prop for BuyableClass Idx {Idx}, triggering UseMoney.")
                    UseSpare((BaseIdx,Idx),option{Player})
                else:
                    # Player is not close enough, do nothing or give feedback
                    #Print("Player is not close to the prop for BuyableClass Idx {Idx}.")

            # Loop through each buyable class and check if the player is close to the prop
            for (Idx -> BuyableClass : TycoonBase.RebirthBuyTriggers):

                # Get The Position of the Buy Prop
                PropTransform := BuyableClass.BuyProp.Prop.GetTransform().Translation

                # Calculate the distance between the player and the prop
                DeltaX := PropTransform.X - PlayerTransform.X
                DeltaY := PropTransform.Y - PlayerTransform.Y
                DeltaZ := PropTransform.Z - PlayerTransform.Z
                SquaredDistance := DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ

                
                
                if (SquaredDistance <= Threshold):
                    # Player is close enough to the prop, trigger the buy action
                    #Print("Player is close to the prop for BuyableClass Idx {Idx}, triggering UseMoney.")
                    UseRebirth((BaseIdx,Idx),option{Player})
                else:
                    # Player is not close enough, do nothing or give feedback
                    #Print("Player is not close to the prop for BuyableClass Idx {Idx}.")




    AddMoney(MaybeAgent: ?agent, Amount: int): void =
        if (VerseUI := PlayerMap[MaybeAgent?]):               
                VerseUI.UpdateMoney(Amount * 1.0)
            
    AddMoney2(Amount: int,MaybeAgent: agent): void =
        if (VerseUI := PlayerMap[MaybeAgent]):               
                VerseUI.UpdateMoney(Amount * 1.0)

    AddZombie(MaybeAgent: ?agent, Amount: int): void =
        if (VerseUI := PlayerMap[MaybeAgent?]):
                VerseUI.UpdateZombie(Amount * 1.0)

    AddZombie2(Amount: int,MaybeAgent: agent): void =
        if (VerseUI := PlayerMap[MaybeAgent]):
                VerseUI.UpdateZombie(Amount * 1.0)

    AddGem(MaybeAgent: ?agent, Amount: int):void=
        if(VerseUI:=PlayerMap[MaybeAgent?]):
                VerseUI.UpdateGem(Amount * 1.0)

    AddGem2(Amount: int,MaybeAgent: agent):void=
        if(VerseUI:=PlayerMap[MaybeAgent]):
                VerseUI.UpdateGem(Amount * 1.0)

    AddSpare(MaybeAgent: ?agent, Amount:int):void=
        if(VerseUI:=PlayerMap[MaybeAgent?]):
            VerseUI.UpdateSpares(Amount * 1.0)

    AddSpare2(Amount: int,MaybeAgent: agent):void=
        if(VerseUI:=PlayerMap[MaybeAgent]):
            VerseUI.UpdateSpares(Amount * 1.0)
         
    AddRebirth(MaybeAgent: ?agent, Amount : int): void =
        if (VerseUI := PlayerMap[MaybeAgent?],Player := player[MaybeAgent?]):
            VerseUI.UpdateRebirth(Amount)
            if :
                
                PersisData := PlayersPersistence[Player]
                set PlayersPersistence[Player]=player_persistent_data:
                    Rebirth:=PersisData.Rebirth + Amount      
            then:
                Print("Already has persistence")
                

    AddRebirth2(Amount: int,MaybeAgent: agent): void =
        if (VerseUI := PlayerMap[MaybeAgent],Player := player[MaybeAgent]):
            VerseUI.UpdateRebirth(Amount)
            if :
                
                PersisData := PlayersPersistence[Player]
                set PlayersPersistence[Player]=player_persistent_data:
                    MakePlayerProfileData<constructor>(PersisData)
                    Rebirth:=PersisData.Rebirth + Amount      
            then:
                Print("Already has persistence")
                
            
    # Starts a loop to give the Money to the player
    LoopGiveMoney(TycoonBase : base_class,VerseUI : verse_ui,Amount:int)<suspends>:void=
        loop:
            if(TycoonBase.StopCurrencys = 1) then return
            Sleep(1.0)
            var multi : float = 1.0
            if(VerseUI.Rebirth > 0):
                set multi = VerseUI.Multiplier
            VerseUI.UpdateMoney(Amount * multi)
            

    # Starts a loop to give the subs to the player
    LoopGiveSubs(TycoonBase : base_class,VerseUI : verse_ui,Amount:int)<suspends>:void=
        loop:
            if(TycoonBase.StopCurrencys = 1) then return
            Sleep(1.0)
            var multi : float = 1.0
            if(VerseUI.Rebirth > 0):
                set multi = VerseUI.Multiplier
            VerseUI.UpdateZombie(Amount * multi)
            
              
    # Starts a loop to give the Gem to the player
    LoopGiveGem(TycoonBase : base_class,VerseUI : verse_ui,Amount:int)<suspends>:void=
        loop:
            if(TycoonBase.StopCurrencys = 1) then return
            Sleep(1.0)
            var multi : float = 1.0
            if(VerseUI.Rebirth > 0):
                set multi = VerseUI.Multiplier
            VerseUI.UpdateGem(Amount * multi)
            

    # Starts a loop to give the Spares to the player
    LoopGiveSpare(TycoonBase : base_class,VerseUI : verse_ui,Amount:int)<suspends>:void=
        loop:
            if(TycoonBase.StopCurrencys = 1) then return
            Sleep(1.0)
            var multi : float = 1.0
            if(VerseUI.Rebirth > 0):
                set multi = VerseUI.Multiplier
            VerseUI.UpdateSpares(Amount * multi)
            
    # Starts a new base for player to avoid code duplication
    LoadNewBase(TycoonBase : base_class,Player : player, VerseUI : verse_ui,Idx : int):void=
        if:
            BuyTrigger := TycoonBase.MoneyBuyTriggers[Idx]
        then:
            if:
                Idx = 0
            then:
                set TycoonBase.firstMoneyUsed = 1
                    # Start Saving Progress
                    # Link the player to the Base
                    spawn{TycoonBase.StartSave()}
                    set TycoonBase.Player = option{Player}
                    if(RebirthValue := PlayersPersistence[Player].Rebirth):
                        VerseUI.InitWidget(RebirthValue)
                    else:
                        VerseUI.InitWidget(0)
            
            IsHiddenBuy := TycoonBase.PropManager.IsHidden(BuyTrigger.BuyProp.ID)
            if(IsHiddenBuy = false):
                Print("Showing Props, setting Hidden To false")
                spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
            else:
                Print("Prop should be with IsHidden = true")

            for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[]):
                        
                        IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                        if(IsHidden = true):
                            Print("Showing Props, setting Hidden To false")
                            if(Idx = 0):
                                Transform := ManagedProp.Prop.GetTransform()
                                Vec3 := Transform.Translation + vector3{Z:=HideLocation}
                                spawn{ManagedProp.Prop.MoveTo(Vec3,Transform.Rotation,1.0)}
                                
                            else:
                                spawn{ShowAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity)}
                            TycoonBase.PropManager.SetHidden(ManagedProp.ID, false)
                        else:
                            Print("Prop should be with IsHidden = true")
                    
            for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if(IsHidden = false):
                        Print("Hiding Props")
                        spawn{HideAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity)}
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, true)
                    else:
                        Print("Prop should be with IsHidden = false")
                
            spawn{Sleep(BuyTrigger.Velocity)} # Sleep until it's not shown

            for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
            for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {Trigger.Disable()}


    # This function will load a old base played by the Player Using Save System Persitance
    # Also initiate a thread for loop and gets the Currency in VerseUI to update the 
    # Currency from past match

    LoadBase(TycoonBase : base_class,Player : player, VerseUI : verse_ui):void=
        if (PersisData := PlayersPersistence[Player]):
            if(BuyTrigger := TycoonBase.MoneyBuyTriggers[0]):
                set TycoonBase.firstMoneyUsed = 1
                if(RebirthValue := PlayersPersistence[Player].Rebirth):
                    VerseUI.InitWidget(RebirthValue)
                else:
                    VerseUI.InitWidget(0)
                spawn{TycoonBase.StartSave()}
                set TycoonBase.Player = option{Player}
                spawn{TycoonBase.LoadBase(PersisData)}
                spawn{VerseUI.LoadCurrency()}
                if(HUD_inter.ShowMoney = true):
                    spawn{LoopGiveMoney(TycoonBase,VerseUI,PersisData.MoneySec)}
                if(HUD_inter.ShowSubs = true):     
                    spawn{LoopGiveSubs(TycoonBase,VerseUI,PersisData.ZombiesSec)}
                if(HUD_inter.ShowGem = true):   
                    spawn{LoopGiveGem(TycoonBase,VerseUI,PersisData.GemsSec)}
                if(HUD_inter.ShowSpare = true):   
                    spawn{LoopGiveSpare(TycoonBase,VerseUI,PersisData.SpareSec)}
                
                
    # Pop Up Message Answer,
    # Load new base
    # Or Load a base that player played before
    OnLoadAnswered(Info : tuple(agent,int)):void=
        YorN := Info(1)
        if:
            Player := player[Info(0)]
            IdxBase := TycoonBaseMap[Player]
            TycoonBase := TycoonBases[IdxBase?]
            VerseUI := PlayerMap[Player]
        then:
            if(YorN = 0):
                Print("Player Choosed Load")
                LoadBase(TycoonBase,Player,VerseUI)
                
            else:
                Print("Player Choosed new")
                if:
                    PersisData := PlayersPersistence[Player]
                    set PlayersPersistence[Player]=player_persistent_data:
                        MakePlayerProfileData<constructor>(PersisData)
                        Ignore := true

                LoadNewBase(TycoonBase,Player,VerseUI,0)
                spawn{DisplayProgressPercentage(TycoonBase,VerseUI)}

    VerifyPlayerBase(Indexes: tuple(int, int),MaybeAgent: ?agent)<transacts>:logic=
        if(Player := player[MaybeAgent?]):
            if(BaseIdx := TycoonBaseMap[Player]?):
                if:
                    UsedTycoonBase := TycoonBases[Indexes(0)]
                    PlayerTycoonBase := TycoonBases[BaseIdx]
                then:
                    if(UsedTycoonBase.Player? <> PlayerTycoonBase.Player?):
                        Print("THIS BASE IS NOT FROM THE PLAYER", ?Color := NamedColors.Red)
                        return false
            else:
                return false
        else:
            return false

        return true

    
    UseRebirth(Indexes: tuple(int, int),MaybeAgent: ?agent): void =
        if(VerifyPlayerBase(Indexes,MaybeAgent) = false) then return

        if (Agent := player[MaybeAgent?], TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.RebirthBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent],BuyTrigger.Bought = false):
            if (VerseUI.Rebirth >= BuyTrigger.Cost):
                Print("Has more Rebirth and 100%")
                Print("Showing the SucceedMessage")
                if(LevelData := LevelVerse.GetData[Agent]):
                    LevelData.LevelManager.AddXP(Agent, LevelPerPurchaseAmount)
                AddRebirth(MaybeAgent, BuyTrigger.ValueToAdd)
                TycoonBase.SucceedMessage.Show(Agent)
                set TycoonBase.PurchasedItems += 1
                set BuyTrigger.Bought = true
                spawn{DisplayProgressPercentage(TycoonBase,VerseUI)}
                if(set PlayerMap[Agent].Score += 1000){}
                
                BuyTrigger.SuccessTrigger.Trigger(Agent)

                IsHiddenBuy := TycoonBase.PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Showing Props, setting Hidden To false")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = true")
                    
                for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if (IsHidden = true):
                        spawn { ShowAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity) }
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, false)

                for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if (IsHidden = false):
                        spawn { HideAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity) }
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, true)

                spawn { Sleep(BuyTrigger.Velocity) }  

                for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {spawn { EnableTrigger(Trigger) } }

            else:
                Print("Showing The fail Message, Rebirth not 100%")
                if(TycoonBase.isBeingUsed = true) then return 
                spawn{TycoonBase.CoolDown(TycoonBase.F_MessageTime)}
                TycoonBase.RebirthFailMessage.SetText(MakeMessageTycoon("YOU NEED MORE {VerseUI.CalculatePrice(0,BuyTrigger.Cost)} TO BUY THIS"))
                TycoonBase.RebirthFailMessage.Show(Agent)
                
    PLAYVFX(Agent : agent, Prop_ : creative_prop)<suspends>:void=
            Result := SpawnProp(VFX, Prop_.GetTransform())
            if(Prop := Result(0)?):
                Sleep(VFXLength)
                Prop.Dispose()
                
    DisplayProgressPercentage(TycoonBase : base_class,VerseUI: verse_ui)<suspends>:void =
        Progress := TycoonBase.CalculateProgressPercentage()
        if:
            ProgressInt := Int[Progress]
        then:
            VerseUI.UpdateBasePercentage(ProgressInt)

    UseMoneyCraft(Indexes: tuple(int, int),Agent: agent):void=
        Print("Received Craft Hit")
        UseMoney(Indexes,option{Agent})

    UseZombieCraft(Indexes: tuple(int, int),Agent: agent):void=
        Print("Received Craft Hit")
        UseZombie(Indexes,option{Agent})

    UseGemCraft(Indexes: tuple(int, int),Agent: agent):void=
        UseGem(Indexes,option{Agent})
    
    UseSpareCraft(Indexes: tuple(int, int),Agent: agent):void=
        UseSpare(Indexes,option{Agent})

    UseMoney(Indexes: tuple(int, int),MaybeAgent: ?agent): void =
        if(VerifyPlayerBase(Indexes,MaybeAgent) = false) then return

        if (Agent := player[MaybeAgent?], TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.MoneyBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent],BuyTrigger.Bought = false):
            if (VerseUI.Money >= BuyTrigger.Cost * 1.0):
                Print("Has more Money")
                Print("Showing the SucceedMessage")
                if(LevelData := LevelVerse.GetData[Agent]):
                    LevelData.LevelManager.AddXP(Agent, LevelPerPurchaseAmount)
                TycoonBase.SucceedMessage.Show(Agent)
                set TycoonBase.PurchasedItems += 1
                set BuyTrigger.Bought = true
                spawn{DisplayProgressPercentage(TycoonBase,VerseUI)}
                if(set PlayerMap[Agent].Score += 1000){}
                
                if(BuyTrigger.DontRemove = false):
                    VerseUI.UpdateMoney(-BuyTrigger.Cost * 1.0)
                if(BuyTrigger.MoreInfo.Only1Time = true):
                        VerseUI.UpdateMoney(BuyTrigger.ValueToAdd * 1.0)
                else:
                        spawn{LoopGiveMoney(TycoonBase, VerseUI, BuyTrigger.ValueToAdd)}
                
                BuyTrigger.SuccessTrigger.Trigger(Agent)
                spawn{PLAYVFX(Agent, BuyTrigger.BuyProp.Prop)}

                if(TycoonBase.firstMoneyUsed = 0):
                    Print("Starting New Base")
                    set TycoonBase.StopCurrencys = 0
                    Print("Setting Stop Currency to 0")
                    if :
                        PersisData := PlayersPersistence[Agent]
                        PersisData.Ignore <> true
                    then:
                        Print("Showing Load Message")
                        LoadMessage.Show(Agent)
                    else:
                        Print("New base loding")
                        LoadNewBase(TycoonBase,Agent,VerseUI,0)
                    
                else:
                    LoadNewBase(TycoonBase,Agent,VerseUI,Indexes(1))
                    
                
            else:
                Print("Money Fail")
                Print("Showing the fail Message")
                if(TycoonBase.isBeingUsed = true) then return 
                spawn{TycoonBase.CoolDown(TycoonBase.F_MessageTime)}
                TycoonBase.FailMessage.SetText(MakeMessageTycoon("YOU NEED MORE {VerseUI.CalculatePrice(1,BuyTrigger.Cost)} TO BUY THIS"))
                TycoonBase.FailMessage.Show(Agent)
                

    UseZombie(Indexes: tuple(int, int),MaybeAgent: ?agent): void =
        if(VerifyPlayerBase(Indexes,MaybeAgent) = false) then return

        if (Agent := player[MaybeAgent?], TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.ZombieBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent],BuyTrigger.Bought = false):
            if (VerseUI.Zombie >= BuyTrigger.Cost * 1.0):
                if(BuyTrigger.DontRemove = false):
                    VerseUI.UpdateZombie(-BuyTrigger.Cost * 1.0)
                if(LevelData := LevelVerse.GetData[Agent]):
                    LevelData.LevelManager.AddXP(Agent, LevelPerPurchaseAmount)
                Print("Showing the SucceedMessage")
                TycoonBase.SucceedMessage.Show(Agent)
                set TycoonBase.PurchasedItems += 1
                set BuyTrigger.Bought = true
                spawn{DisplayProgressPercentage(TycoonBase,VerseUI)}
                if(set PlayerMap[Agent].Score += 1000){}
                BuyTrigger.SuccessTrigger.Trigger(Agent)
                if(BuyTrigger.MoreInfo.Only1Time = true):
                        VerseUI.UpdateZombie(BuyTrigger.ValueToAdd * 1.0)
                else:
                    spawn{LoopGiveSubs(TycoonBase, VerseUI, BuyTrigger.ValueToAdd)}
                
                spawn{PLAYVFX(Agent, BuyTrigger.BuyProp.Prop)}

                IsHiddenBuy := TycoonBase.PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Showing Props, setting Hidden To false")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = true")
                

                for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if(IsHidden = true):
                        spawn{ShowAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity)}
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, false)
                    else:
                        Print("Prop should be with IsHidden = true")
                
                for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if(IsHidden = false):
                        spawn{HideAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity)}
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, true)
                    else:
                        Print("Prop should be with IsHidden = false")

                for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {spawn { EnableTrigger(Trigger) } }
            else:
                Print("Zombie Fail")
                Print("Showing the fail Message")
                if(TycoonBase.isBeingUsed = true) then return 
                spawn{TycoonBase.CoolDown(TycoonBase.F_MessageTime)}

                TycoonBase.FailMessage.SetText(MakeMessageTycoon("YOU NEED MORE {VerseUI.CalculatePrice(2,BuyTrigger.Cost)} TO BUY THIS"))
                TycoonBase.FailMessage.Show(Agent)
               


   

    UseGem(Indexes: tuple(int, int),MaybeAgent: ?agent): void =
        if(VerifyPlayerBase(Indexes,MaybeAgent) = false) then return

        if (Agent := player[MaybeAgent?], TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.GemBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent],BuyTrigger.Bought = false):
            if (VerseUI.Gem >= BuyTrigger.Cost * 1.0):
                if(BuyTrigger.DontRemove = false):
                    VerseUI.UpdateGem(-BuyTrigger.Cost * 1.0)
                Print("Showing the SucceedMessage")
                if(LevelData := LevelVerse.GetData[Agent]):
                    LevelData.LevelManager.AddXP(Agent, LevelPerPurchaseAmount)
                TycoonBase.SucceedMessage.Show(Agent)
                set TycoonBase.PurchasedItems += 1
                set BuyTrigger.Bought = true
                spawn{DisplayProgressPercentage(TycoonBase,VerseUI)}
                if(set PlayerMap[Agent].Score += 1000){}
                if(BuyTrigger.MoreInfo.Only1Time = true):
                    VerseUI.UpdateGem(BuyTrigger.ValueToAdd * 1.0)
                else:
                    spawn{LoopGiveGem(TycoonBase, VerseUI, BuyTrigger.ValueToAdd)}
                
                BuyTrigger.SuccessTrigger.Trigger(Agent)
                spawn{PLAYVFX(Agent, BuyTrigger.BuyProp.Prop)}
                IsHiddenBuy := TycoonBase.PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Showing Props, setting Hidden To false")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = true")

                for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if(IsHidden = true):
                        spawn{ShowAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity)}
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, false)
                    else:
                        Print("Prop should be with IsHidden = true")
                
                for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if(IsHidden = false):
                        spawn{HideAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity)}
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, true)
                    else:
                        Print("Prop should be with IsHidden = false")
                
                spawn{Sleep(BuyTrigger.Velocity)}
                for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {Trigger.Disable()}
            else:
                Print("Gem Fail")
                Print("Showing the fail Message")
                if(TycoonBase.isBeingUsed = true) then return 
                spawn{TycoonBase.CoolDown(TycoonBase.F_MessageTime)}
                TycoonBase.FailMessage.SetText(MakeMessageTycoon("YOU NEED MORE {VerseUI.CalculatePrice(3,BuyTrigger.Cost)} TO BUY THIS"))
                TycoonBase.FailMessage.Show(Agent)
                


    UseSpare(Indexes: tuple(int, int),MaybeAgent: ?agent): void =
        if(VerifyPlayerBase(Indexes,MaybeAgent) = false) then return

        if (Agent := player[MaybeAgent?], TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.SparesBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent],BuyTrigger.Bought = false):
            if (VerseUI.Spares >= BuyTrigger.Cost * 1.0):
                if(BuyTrigger.DontRemove = false):
                    VerseUI.UpdateSpares(-BuyTrigger.Cost * 1.0)
                if(LevelData := LevelVerse.GetData[Agent]):
                    LevelData.LevelManager.AddXP(Agent, LevelPerPurchaseAmount)
                TycoonBase.SucceedMessage.Show(Agent)
                set TycoonBase.PurchasedItems += 1
                set BuyTrigger.Bought = true
                spawn{DisplayProgressPercentage(TycoonBase,VerseUI)}    
                if(set PlayerMap[Agent].Score += 1000){}
                if(BuyTrigger.MoreInfo.Only1Time = true):
                        VerseUI.UpdateSpares(BuyTrigger.ValueToAdd * 1.0)
                else:
                        spawn{LoopGiveSpare(TycoonBase, VerseUI, BuyTrigger.ValueToAdd)}
                
                BuyTrigger.SuccessTrigger.Trigger(Agent)
                spawn{PLAYVFX(Agent, BuyTrigger.BuyProp.Prop)}
                
                IsHiddenBuy := TycoonBase.PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Showing Props, setting Hidden To false")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = true")

                for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if(IsHidden = true):
                        spawn{ShowAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity)}
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, false)
                    else:
                        Print("Prop should be with IsHidden = true")
                
                for (ManagedProp: BuyTrigger.HideProps, ManagedProp.Prop.IsValid[]):
                    
                    IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
                    if(IsHidden = false):
                        spawn{HideAnimationProp(ManagedProp.Prop, BuyTrigger.Velocity)}
                        TycoonBase.PropManager.SetHidden(ManagedProp.ID, true)
                    else:
                        Print("Prop should be with IsHidden = false")
                
                for (Trigger: BuyTrigger.MoreInfo.EnableTriggers) {Trigger.Enable()}
                for (Trigger: BuyTrigger.MoreInfo.DisableTriggers) {Trigger.Disable()}
            else:
                Print("Spare Fail")
                Print("Showing the fail Message")

                if(TycoonBase.isBeingUsed = true) then return 
                spawn{TycoonBase.CoolDown(TycoonBase.F_MessageTime)}
                TycoonBase.FailMessage.SetText(MakeMessageTycoon("YOU NEED MORE {VerseUI.CalculatePrice(4,BuyTrigger.Cost)} TO BUY THIS"))
                TycoonBase.FailMessage.Show(Agent)
                
              

    # 0 -> BaseIdx
    # 1 -> Idx of the class
    # 2 -> min value
    # 3 -> Max value
    RandomMoney(MaybeAgent: ?agent, Indexes: tuple(int, int,int,int)): void =
        if(Player := player[MaybeAgent?]):
            if(BaseIdx := TycoonBaseMap[Player]?):
                if:
                    UsedTycoonBase := TycoonBases[Indexes(0)]
                    PlayerTycoonBase := TycoonBases[BaseIdx]
                then:
                    if(UsedTycoonBase.Player? <> PlayerTycoonBase.Player?):
                        Print("THIS BASE IS NOT FROM THE PLAYER", ?Color := NamedColors.Red)
                        UsedTycoonBase.FailMessage.Show(Player)
                        return
            
        else:
            return

        if (Agent := MaybeAgent?, TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.MoneyBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent]):
            RandomValue := GetRandomInt(Indexes(2),Indexes(3))
            Message := MakeMessageTycoon("+{RandomValue}$")
            VerseUI.UpdateMoney(RandomValue * 1.0)

    # 0 -> BaseIdx
    # 1 -> Idx of the class
    # 2 -> min value
    # 3 -> Max value
    RandomZombie(MaybeAgent: ?agent, Indexes: tuple(int, int,int,int)): void =
        if(Player := player[MaybeAgent?]):
            if(BaseIdx := TycoonBaseMap[Player]?):
                if:
                    UsedTycoonBase := TycoonBases[Indexes(0)]
                    PlayerTycoonBase := TycoonBases[BaseIdx]
                then:
                    if(UsedTycoonBase.Player? <> PlayerTycoonBase.Player?):
                        Print("THIS BASE IS NOT FROM THE PLAYER", ?Color := NamedColors.Red)
                        UsedTycoonBase.FailMessage.Show(Player)
                        return
            
        else:
            return

        if (Agent := MaybeAgent?, TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.ZombieBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent]):
            RandomValue := GetRandomInt(Indexes(2),Indexes(3))
            Message := MakeMessageTycoon("{RandomValue}")
            VerseUI.UpdateZombie(RandomValue * 1.0)
            
    # 0 -> BaseIdx
    # 1 -> Idx of the class
    # 2 -> min value
    # 3 -> Max value
    RandomGem(MaybeAgent: ?agent, Indexes: tuple(int, int,int,int)): void =
        if(Player := player[MaybeAgent?]):
            if(BaseIdx := TycoonBaseMap[Player]?):
                if:
                    UsedTycoonBase := TycoonBases[Indexes(0)]
                    PlayerTycoonBase := TycoonBases[BaseIdx]
                then:
                    if(UsedTycoonBase.Player? <> PlayerTycoonBase.Player?):
                        Print("THIS BASE IS NOT FROM THE PLAYER", ?Color := NamedColors.Red)
                        UsedTycoonBase.FailMessage.Show(Player)
                        return
            
        else:
            return

        if (Agent := MaybeAgent?, TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.GemBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent]):
            RandomValue := GetRandomInt(Indexes(2),Indexes(3))
            Message := MakeMessageTycoon("{RandomValue}")
            VerseUI.UpdateGem(RandomValue * 1.0)

    # 0 -> BaseIdx
    # 1 -> Idx of the class
    # 2 -> min value
    # 3 -> Max value
    RandomSpare(MaybeAgent: ?agent, Indexes: tuple(int, int,int,int)): void =
        if(Player := player[MaybeAgent?]):
            if(BaseIdx := TycoonBaseMap[Player]?):
                if:
                    UsedTycoonBase := TycoonBases[Indexes(0)]
                    PlayerTycoonBase := TycoonBases[BaseIdx]
                then:
                    if(UsedTycoonBase.Player? <> PlayerTycoonBase.Player?):
                        Print("THIS BASE IS NOT FROM THE PLAYER", ?Color := NamedColors.Red)
                        UsedTycoonBase.FailMessage.Show(Player)
                        return
            
        else:
            return

        if (Agent := MaybeAgent?, TycoonBase := TycoonBases[Indexes(0)], BuyTrigger := TycoonBase.SparesBuyTriggers[Indexes(1)], VerseUI := PlayerMap[Agent]):
            RandomValue := GetRandomInt(Indexes(2),Indexes(3))
            Message := MakeMessageTycoon("{RandomValue}")
            VerseUI.UpdateSpares(RandomValue * 1.0)

                
                



    EnableTrigger(Trigger : trigger_device)<suspends>:void=
        Sleep(1.5)
        Trigger.Enable()

    HandlePlayerJoin(InPlayer: player) : void =
        if (PlayerUI := GetPlayerUI[InPlayer]):
            if (Canvas := PlayerMap[InPlayer].Canvas?):
                PlayerUI.RemoveWidget(Canvas)

            VerseUI := verse_ui{OurPlayerUI := PlayerUI, OurPlayer := InPlayer, ShowMoney := HUD_inter.ShowMoney, ShowSubs := HUD_inter.ShowSubs, ShowGem := HUD_inter.ShowGem, ShowSpare := HUD_inter.ShowSpare, ShowRebirth := HUD_inter.ShowRebirth, SAVE_TIME_CONST_DONT_CHANGE := SAVE_TIME_CONST_DONT_CHANGE,Multiplier := Multiplier,UseMultiplier := HUD_inter.UseMultiplier}
            if (set PlayerMap[InPlayer] = VerseUI) {}
            spawn{StartLeaderBoard(InPlayer,PlayerUI)}

    StartLeaderBoard(Player : player,PlayerUI : player_ui)<suspends>:void=
        loop:
            Sleep(3.0)
            if(OldUI := LeaderBoardMap[Player]):
                PlayerUI.RemoveWidget(OldUI)
            NewCanvas := GetNewLeaderboard(Player)
                PlayerUI.AddWidget(NewCanvas)
                if(set LeaderBoardMap[Player] = NewCanvas){}
            
    GetName<localizes>(Player : player,Value : int):message="⭐ {Player}: {Value}"
    GetNewLeaderboard(InPlayer : player):canvas=
        Players := GetPlayspace().GetPlayers()
        var PlayerScores : []tuple(player, float) = array{}
        var MyValue : int = 0
        var MaxValue : int = 0
        
        var LeaderBoardUI : canvas = canvas{}

        # Gather scores for all players
        for(Player : Players):
            if (VerseUI := PlayerMap[Player], Subs := VerseUI.Score):
                SubsCount := Subs
                set PlayerScores += array{(Player, SubsCount * 1.0)}
                
                if (SubsCount > MaxValue):
                    set MaxValue = SubsCount
    
                if (Player = InPlayer):
                    set MyValue = SubsCount
                    
        # Sort players by their scores in descending order
        SortedPlayerScores := SortPlayerScores(PlayerScores)
        
        # Add the rest of the players to the leaderboard
        var I : int = 0
        for (Idx -> PlayerScore : SortedPlayerScores):
            Player := PlayerScore(0)
            Score := PlayerScore(1)

            if(I = 0):

                LeaderBoardUI.AddWidget(canvas_slot:
                    Anchors:=anchors{Minimum:=vector2{X:=0.746285,Y:=0.068001},Maximum:=vector2{X:=0.986079,Y:=0.111919}}
                    Offsets:=margin{}
                    SizeToContent:=true
                    Widget:=texture_block{DefaultImage := Images.BgImage}
                )
        
                LeaderBoardUI.AddWidget(canvas_slot:
                    Anchors:=anchors{Minimum:=vector2{X:=0.753344,Y:=0.072146 + I*0.06},Maximum:=vector2{X:=0.959375,Y:=0.100000 + I*0.06}}
                    Offsets:=margin{}
                    SizeToContent:=true
                    Widget:=BuildPlayerTextBlock(Player, Score, NamedColors.Gold)
                )
            else:
                LeaderBoardUI.AddWidget(canvas_slot:
                    Anchors:=anchors{Minimum:=vector2{X:=0.746285,Y:=0.068001 + I*0.06},Maximum:=vector2{X:=0.986079,Y:=0.111919 + I*0.06}}
                    Offsets:=margin{}
                    SizeToContent:=true
                    Widget:=texture_block{DefaultImage := Images.BgImage}
                )
        
                LeaderBoardUI.AddWidget(canvas_slot:
                    Anchors:=anchors{Minimum:=vector2{X:=0.753344,Y:=0.072146 + I*0.06},Maximum:=vector2{X:=0.959375,Y:=0.100000 + I*0.06}}
                    Offsets:=margin{}
                    SizeToContent:=true
                    Widget:=BuildPlayerTextBlock(Player, Score, NamedColors.White)
                )
    
            set I += 1
    
        return LeaderBoardUI
        
    
    # Function to build the text block for a player
    BuildPlayerTextBlock(Player : player, Score : float, TextColor : color):text_block=
        TextBlock := text_block{}
        if(ScoreToInt := Int[Score]):
            Name := GetName(Player, ScoreToInt)
            TextBlock.SetText(Name)
            TextBlock.SetTextColor(TextColor)
            TextBlock.SetShadowColor(color{R:=0.0, G:=0.0, B:=0.0})
            TextBlock.SetShadowOffset(option{vector2{X:=4.0, Y:=4.0}})
            TextBlock.SetShadowOpacity(1.0)
        return TextBlock

    # Function to sort players by their scores in descending order
    SortPlayerScores(PlayerScores : []tuple(player, float)) : []tuple(player, float) =
        if (PlayerScores.Length <= 0):
            return PlayerScores

        Number := PlayerScores.Length * 1.0 / 2.0
        Print("Number := {Number}")
        if(Pivot := PlayerScores[Int[Number]]):

            var Less : []tuple(player, float) = array{}
            var Equal : []tuple(player, float) = array{}
            var Greater : []tuple(player, float) = array{}

            for (PS : PlayerScores):
                if (PS(1) < Pivot(1)):
                    set Less += array{PS}
                else if (PS(1) > Pivot(1)):
                    set Greater += array{PS}
                else:
                    set Equal += array{PS}

            return SortPlayerScores(Greater) + Equal + SortPlayerScores(Less)

        return PlayerScores



    ResetTycoon(MaybeAgent : ?agent):void=
        if:
            Player := player[MaybeAgent?]
            VerseUI := PlayerMap[Player]
            PlayerUI := GetPlayerUI[Player]
        then:
            VerseUI.RemoveUI()
            set PlayerMap = RemoveKeyFromMap(PlayerMap,Player)
            VerseUINew := verse_ui{OurPlayerUI := PlayerUI, OurPlayer := Player, ShowMoney := HUD_inter.ShowMoney, ShowSubs := HUD_inter.ShowSubs, ShowGem := HUD_inter.ShowGem, ShowSpare := HUD_inter.ShowSpare, ShowRebirth := HUD_inter.ShowRebirth, SAVE_TIME_CONST_DONT_CHANGE := SAVE_TIME_CONST_DONT_CHANGE,Multiplier := Multiplier,UseMultiplier := HUD_inter.UseMultiplier}
            if (set PlayerMap[Player] = VerseUINew) {}
            HandlePlayerLeft(Player)

    HideAllProps(TycoonBase: base_class, PropManager: prop_manager): void =
        
        for (Idx -> BuyTrigger: TycoonBase.MoneyBuyTriggers):
            set BuyTrigger.Bought = false
            IsHiddenBuy := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Hiding Props, setting Hidden To true")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = false")

            for (ManagedProp: BuyTrigger.ShowProps, Transform := ManagedProp.Prop.GetTransform()):
                if( not ManagedProp.Prop.IsValid[]):
                    Print("Prop is not valid!!!", ?Color := NamedColors.Red)
                else:
                    IsHidden := PropManager.IsHidden(ManagedProp.ID)
                    if (IsHidden = false):
                        spawn {
                            ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z := -HideLocation}, Transform.Rotation, BuyTrigger.Velocity)
                        }
                        PropManager.SetHidden(ManagedProp.ID, true)
                    else:
                        Print("prop is already hidden")
        for (Idx -> BuyTrigger : TycoonBase.ZombieBuyTriggers):
            set BuyTrigger.Bought = false
            IsHiddenBuy := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Hiding Props, setting Hidden To true")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = false")

            for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[], Transform := ManagedProp.Prop.GetTransform()):
                IsHidden := PropManager.IsHidden(ManagedProp.ID)
                if (IsHidden = false):
                    spawn {
                        ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z := -HideLocation}, Transform.Rotation, BuyTrigger.Velocity)
                    }
                    PropManager.SetHidden(ManagedProp.ID, true)
                else:
                    Print("prop is already hidden")
            
        for (Idx -> BuyTrigger: TycoonBase.GemBuyTriggers):
            set BuyTrigger.Bought = false
            IsHiddenBuy := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Hiding Props, setting Hidden To true")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = false")

            for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[], Transform := ManagedProp.Prop.GetTransform()):
                IsHidden := PropManager.IsHidden(ManagedProp.ID)
                if (IsHidden = false):
                    spawn {
                        ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z := -HideLocation}, Transform.Rotation, BuyTrigger.Velocity)
                    }
                    PropManager.SetHidden(ManagedProp.ID, true)
                else:
                    Print("prop is already hidden")
            
        for (Idx -> BuyTrigger: TycoonBase.SparesBuyTriggers):
            set BuyTrigger.Bought = false
            IsHiddenBuy := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Hiding Props, setting Hidden To true")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = false")

            for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[], Transform := ManagedProp.Prop.GetTransform()):
                IsHidden := PropManager.IsHidden(ManagedProp.ID)
                if (IsHidden = false):
                    spawn {
                        ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z := -HideLocation}, Transform.Rotation, BuyTrigger.Velocity)
                    }
                    PropManager.SetHidden(ManagedProp.ID, true)
                else:
                    Print("prop is already hidden")
            

        for (Idx -> BuyTrigger: TycoonBase.RebirthBuyTriggers):
            set BuyTrigger.Bought = false
            IsHiddenBuy := PropManager.IsHidden(BuyTrigger.BuyProp.ID)
                if(IsHiddenBuy = false):
                    Print("Hiding Props, setting Hidden To true")
                    spawn{HideAnimationProp(BuyTrigger.BuyProp.Prop, BuyTrigger.Velocity)}
                    TycoonBase.PropManager.SetHidden(BuyTrigger.BuyProp.ID, true)
                else:
                    Print("Prop should be with IsHidden = false")

            for (ManagedProp: BuyTrigger.ShowProps, ManagedProp.Prop.IsValid[], Transform := ManagedProp.Prop.GetTransform()):
                IsHidden := PropManager.IsHidden(ManagedProp.ID)
                if (IsHidden = false):
                    spawn {
                        ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z := -HideLocation}, Transform.Rotation, BuyTrigger.Velocity)
                    }
                    PropManager.SetHidden(ManagedProp.ID, true)
                else:
                    Print("prop is already hidden")
            
   
    HandlePlayerLeft(InPlayer: player): void =
        if (Idx := TycoonBaseMap[InPlayer]?, TycoonBase := TycoonBases[Idx], set TycoonBaseMap[InPlayer] = false):
            TycoonBase.OnLeftTrigger.Trigger(InPlayer)
            set TycoonBase.StopCurrencys = 1
            HideAllProps(TycoonBase,TycoonBase.PropManager)
            set TycoonBase.Player = false
            set TycoonBase.VerseUI_pointer = false
            # Show the First Button To be able to claim again
            ManagedProp := TycoonBase.InitButton
            IsHidden := TycoonBase.PropManager.IsHidden(ManagedProp.ID)
            Transform := ManagedProp.Prop.GetTransform()
            if (IsHidden = true):
                    spawn {
                        ManagedProp.Prop.MoveTo(Transform.Translation + vector3{Z := HideLocation}, Transform.Rotation, 1.0)
                    }
                    TycoonBase.PropManager.SetHidden(ManagedProp.ID, false)
            else:
                Print("prop is already show")

            if(VerseUI := PlayerMap[InPlayer]):
                # Stop All the loops by setting Flag To Stop
                spawn{VerseUI.ResetCurrencys()}
            
            





SecondsToString(seconds: int): string =
    
    var hours: int = 0
    var minutes: int = 0
    var remainingSeconds: int = seconds

    # Calculate hours by subtracting 3600 seconds 
    loop: 
        if(remainingSeconds >= 3600 ):
        
            set hours += 1
            set remainingSeconds -= 3600
        else:
            break
  
    
    # Calculate minutes 

    loop: 
        
        if(remainingSeconds >= 60 ):
           set minutes += 1
           set remainingSeconds -= 60
        else:
            break

    # remainingSeconds now represents the leftover seconds
    return "{minutes}:{remainingSeconds}"