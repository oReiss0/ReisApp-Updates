using { /Fortnite.com/Game }

# INTEGRAÇÃO REAL PARA A SUA CLASSE AnimatronicNPC
# (sem placeholders "..." e pronta para colar diretamente no código enviado)

# 1) ADICIONE ESTE CAMPO junto das outras subscriptions:
# var DamagedSubscription : ?cancelable = false

# 2) ADICIONE ESTES MÉTODOS dentro da classe AnimatronicNPC:

GetInstigatorPlayer(Result:damage_result)<transacts>:?player=
    if:
        Instigator := Result.Instigator?
        InstigatorAgent := Instigator.GetInstigatorAgent[]
        InstigatorPlayer := player[InstigatorAgent]
    then:
        return option{InstigatorPlayer}
    false

OnDamaged(Result:damage_result):void=
    if(AttackerPlayer := GetInstigatorPlayer(Result)?):
        if(AttackerCharacter := AttackerPlayer.GetFortCharacter[]):
            if(AttackerCharacter.IsActive[]):
                set LastSeenTargetPos = option{FromVector3(AttackerCharacter.GetTransform().Translation)}
                RefreshVisualConfirmation()
                ChasePrint("DamagedEvent: jogador agressor definido como alvo.", ?LogColor := NamedColors.Red)
                AcquireTarget(AttackerPlayer, "DamagedEvent")

# 3) NO OnBegin<override>(), após obter AgentFC, adicione:
# set DamagedSubscription = option{AgentFC.DamagedEvent().Subscribe(OnDamaged)}

# 4) NO OnEnd<override>(), adicione o cancelamento:
# if(DamageSub := DamagedSubscription?):
#     DamageSub.Cancel()

# 5) NO TOPO DO ARQUIVO PRINCIPAL, adicione:
# using { /Fortnite.com/Game }
