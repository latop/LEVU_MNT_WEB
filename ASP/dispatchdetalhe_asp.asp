<!--#include file="verificaloginaeropfunc.asp"-->
<%

	Dim strEdition
	Dim strCaptain
	Dim strNomeGuerra, strCodDac
	Dim strPreparedBy
	Dim strFrota
	Dim strEngineRating
	Dim strFlaps, strStabTrim
	Dim strBleeds
	Dim strWindDirection
	Dim strWind
	Dim strTemperature
	Dim strQNH
	Dim strRWY
	Dim strElevation
	Dim strRwyLimitedTakeoff
	Dim strClimbLimitedTakeoff
	Dim strQnhCorrection
	Dim strRwyLimitedCorrectedMtow
	Dim strRwnlw
	Dim strClimbLimitedCorrectedMtow
	Dim strMaximumWeightForTakeoff
	Dim strMrwTaxiOutFuel
	Dim strMzfwTakeoffFuel
	Dim strMlwTripFuel
	Dim strAllowedWeightForTakeoff
	Dim strBasicOperatingWeight
	Dim strAllowedTrafficLoad
	Dim strMaximumRampWeight
	Dim strTaxiOutFuel
	Dim strMaximumZeroFuelWeight
	Dim intTakeoffFuel
	Dim strMaximumLandingWeight
	Dim intTripFuel
	Dim strMaximumFlightPlanWeight
	Dim strDataAlteracao, dtDataAlteracao
	Dim strDataDispatch, dtDataDispatch
	Dim strSiglaEmpresa
	Dim strRouteOrigem
	Dim strRouteDestino
	Dim strStdPartidaPlanej
	Dim strStaChegadaPlanej
	Dim strPboIndex
	Dim strAeronavePboArm
	Dim strCrewConf
	Dim strFwdCargo
	Dim strAftCargo
	Dim strPaxAdt
	Dim strPaxChd
	Dim strPaxInf
	Dim strZeroFuelWeight
	Dim strZfwIndex
	Dim strTakeoffWeight
	Dim strTowIndex
	Dim strLandingWeight
	Dim strLwIndex
	Dim strActualUnderload
	Dim strNrVoo
	Dim strRestrictBy
	Dim strCombMain1, strCombCtr, strCombMain2, strTotal
	Dim strRemarks
	Dim strPlanoVoo
	Dim strCarregChegPorao1
	Dim strCarregChegPorao2
	Dim strCarregChegPorao3
	Dim strCarregChegPorao4
	Dim strCarregPartPorao1
	Dim strCarregPartPorao2
	Dim strCarregPartPorao3
	Dim strCarregPartPorao4
	Dim strCarregInstrucao
	Dim strRwyCondition
	Dim strTakeOffMode
	Dim intSeqVooDia, intSeqTrecho
	Dim strPrefixoAeronave
	Dim strAeronaveMtogw
	Dim intBagCargaCorreio
	Dim intSomaPoroes
	Dim intPaxPesoTotal
    Dim pesoAdulto
    Dim pesoCrianca
    Dim pesoInfo

Sub PreencherDetalheEtapa()

	intSeqVooDia = Request.QueryString("seqvoodia")
	intSeqTrecho = Request.QueryString("seqtrecho")

	If (IsVazio(intSeqVooDia) Or IsVazio(intSeqTrecho)) Then
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If

	Dim objConn
	Set objConn = CreateObject("ADODB.CONNECTION")
	objConn.ConnectionTimeout = 120
	objConn.Open (StringConexaoSqlServer)
	objConn.Execute "SET DATEFORMAT ymd"

	Dim strSqlSelect
	strSqlSelect = " SELECT "
	strSqlSelect = strSqlSelect & " DTD.numedicao EDITION, "
	strSqlSelect = strSqlSelect & " TRP.nomeguerra CAPTAIN, "
	strSqlSelect = strSqlSelect & " TRP.coddac COD_DAC, "
	strSqlSelect = strSqlSelect & " USU.usuario PREPARED_BY, "
	strSqlSelect = strSqlSelect & " USU.codanac COD_ANAC, "
	strSqlSelect = strSqlSelect & " Fr.codfrota FROTA, "
	strSqlSelect = strSqlSelect & " DTD.engine ENGINE_RATING, "
	strSqlSelect = strSqlSelect & " DTD.codflap FLAPS, "
	strSqlSelect = strSqlSelect & " DTD.stabtrim STAB_TRIM, "
	strSqlSelect = strSqlSelect & " DTD.combmain1 COMB_MAIN1, "
	strSqlSelect = strSqlSelect & " DTD.combmain2 COMB_MAIN2, "
	strSqlSelect = strSqlSelect & " DTD.combctr COMB_CTR, "
	strSqlSelect = strSqlSelect & " DTD.observacao REMARKS, "
	strSqlSelect = strSqlSelect & " DTD.codbleed BLEEDS, "
	strSqlSelect = strSqlSelect & " DTD.winddirection WIND_DIRECTION, "
	strSqlSelect = strSqlSelect & " DTD.wind WIND, "
	strSqlSelect = strSqlSelect & " DTD.temperature TEMPERATURE, "
	strSqlSelect = strSqlSelect & " DTD.qnh QNH, "
	strSqlSelect = strSqlSelect & " DTD.codpista RWY, "
	strSqlSelect = strSqlSelect & " DTD.elevation ELEVATION, "
	strSqlSelect = strSqlSelect & " DTD.rwnw RWY_LIMITED_TAKEOFF, "
	strSqlSelect = strSqlSelect & " DTD.climbw CLIMB_LIMITED_TAKEOFF, "
	strSqlSelect = strSqlSelect & " DTD.rwnwcorr - DTD.rwnw QNH_CORRECTION, "
	strSqlSelect = strSqlSelect & " DTD.rwnwcorr RWY_LIMITED_CORRECTED_MTOW, "
	strSqlSelect = strSqlSelect & " DTD.rwnlw RWNLW, "
	strSqlSelect = strSqlSelect & " DTD.climbwcorr CLIMB_LIMITED_CORRECTED_MTOW, "
	strSqlSelect = strSqlSelect & " DTD.mtow MAXIMUM_WEIGHT_FOR_TAKEOFF, "
	strSqlSelect = strSqlSelect & " DTD.mrw - DTD.combtaxi MRW_TAXI_OUT_FUEL, "
	strSqlSelect = strSqlSelect & " DTD.mzfw + DTD.combtotal MZFW_TAKEOFF_FUEL, "
	strSqlSelect = strSqlSelect & " DTD.mlw + DTD.combtrip MLW_TRIP_FUEL, "
	strSqlSelect = strSqlSelect & " DTD.takeoffw ALLOWED_WEIGHT_FOR_TAKEOFF, "
	strSqlSelect = strSqlSelect & " DTD.pbo BASIC_OPERATING_WEIGHT, "
	strSqlSelect = strSqlSelect & " DTD.allowto ALLOWED_TRAFFIC_LOAD, "
	strSqlSelect = strSqlSelect & " DTD.mrw MAXIMUM_RAMP_WEIGHT, "
	strSqlSelect = strSqlSelect & " DTD.combtaxi TAXI_OUT_FUEL, "
	strSqlSelect = strSqlSelect & " DTD.mzfw MAXIMUM_ZERO_FUEL_WEIGHT, "
	strSqlSelect = strSqlSelect & " DTD.combtotal TAKEOFF_FUEL, "
	strSqlSelect = strSqlSelect & " DTD.mlw MAXIMUM_LANDING_WEIGHT, "
	strSqlSelect = strSqlSelect & " DTD.combtrip TRIP_FUEL, "
	strSqlSelect = strSqlSelect & " DTD.mfpw MAXIMUM_FLIGHT_PLAN_WEIGHT, "
	strSqlSelect = strSqlSelect & " DTD.dthralteracao DATA_ALTERACAO, "
	strSqlSelect = strSqlSelect & " DTDP.dthrdispatch DATA_DISPATCH, "
	strSqlSelect = strSqlSelect & " Param.siglaempresa SIGLA_EMPRESA, "
	strSqlSelect = strSqlSelect & " Param.pesoadt PESOADT, "
	strSqlSelect = strSqlSelect & " Param.pesochd PESOCHD, "
	strSqlSelect = strSqlSelect & " Param.pesoinf PESOINF, "
	strSqlSelect = strSqlSelect & " ApOrig.codiata ROUTE_ORIGEM, "
	strSqlSelect = strSqlSelect & " ApDest.codiata ROUTE_DESTINO, "
	strSqlSelect = strSqlSelect & " DT.partidaplanej STD_PARTIDA_PLANEJ, "
	strSqlSelect = strSqlSelect & " DT.chegadaplanej STA_CHEGADA_PLANEJ, "
	strSqlSelect = strSqlSelect & " DTD.pboindex PBO_INDEX, "
	strSqlSelect = strSqlSelect & " DTD.crewconf CREW_CONF, "
	strSqlSelect = strSqlSelect & " DTD.carga1 FWD_CARGO, "
	strSqlSelect = strSqlSelect & " DTD.carga2 AFT_CARGO, "
	strSqlSelect = strSqlSelect & " DTD.paxadt PAX_ADT, "
	strSqlSelect = strSqlSelect & " DTD.paxchd PAX_CHD, "
	strSqlSelect = strSqlSelect & " DTD.paxinf PAX_INF, "
	strSqlSelect = strSqlSelect & " DTD.zfw ZERO_FUEL_WEIGHT, "
	strSqlSelect = strSqlSelect & " DTD.zfwindex ZFW_INDEX, "
	strSqlSelect = strSqlSelect & " DTD.tow TAKEOFF_WEIGHT, "
	strSqlSelect = strSqlSelect & " DTD.towindex TOW_INDEX, "
	strSqlSelect = strSqlSelect & " DTD.lw LANDING_WEIGHT, "
	strSqlSelect = strSqlSelect & " DTD.lwindex LW_INDEX, "
	strSqlSelect = strSqlSelect & " DTD.underload ACTUAL_UNDERLOAD, "
	strSqlSelect = strSqlSelect & " DV.nrvoo NR_VOO, "
	strSqlSelect = strSqlSelect & " DTD.planovoo PLANO_VOO, "
	strSqlSelect = strSqlSelect & " DTD.carregchegporao1 CARREG_CHEG_PORAO1, "
	strSqlSelect = strSqlSelect & " DTD.carregchegporao2 CARREG_CHEG_PORAO2, "
	strSqlSelect = strSqlSelect & " DTD.carregchegporao3 CARREG_CHEG_PORAO3, "
	strSqlSelect = strSqlSelect & " DTD.carregchegporao4 CARREG_CHEG_PORAO4, "
	strSqlSelect = strSqlSelect & " DTD.carregpartporao1 CARREG_PART_PORAO1, "
	strSqlSelect = strSqlSelect & " DTD.carregpartporao2 CARREG_PART_PORAO2, "
	strSqlSelect = strSqlSelect & " DTD.carregpartporao3 CARREG_PART_PORAO3, "
	strSqlSelect = strSqlSelect & " DTD.carregpartporao4 CARREG_PART_PORAO4, "
	strSqlSelect = strSqlSelect & " DTD.carreginstrucao CARREG_INSTRUCAO, "
	strSqlSelect = strSqlSelect & " DTD.rwycondition RWY_CONDITION, "
	strSqlSelect = strSqlSelect & " DTD.takeoffmode TAKE_OFF_MODE, "
	strSqlSelect = strSqlSelect & " Aeronave.prefixo PREFIXO_AERONAVE, "
	strSqlSelect = strSqlSelect & " Aeronave.mtogw AERONAVE_MTOGW, "
	strSqlSelect = strSqlSelect & " AeronavePbo.arm AERONAVE_PBO_ARM, "
	strSqlSelect = strSqlSelect & " (DT.baglivre + DT.bagexcesso + "
	strSqlSelect = strSqlSelect & "  DT.cargapaga + DT.cargagratis + "
	strSqlSelect = strSqlSelect & "  DT.correioao + DT.correiolc) BAG_CARGA_CORREIO, "
	strSqlSelect = strSqlSelect & " (COALESCE(DTDP.porao1, 0) + COALESCE(DTDP.porao2, 0) + "
	strSqlSelect = strSqlSelect & "  COALESCE(DTDP.porao3, 0) + COALESCE(DTDP.porao4, 0) + "
    strSqlSelect = strSqlSelect & "  COALESCE(DTDP.porao5, 0) + COALESCE(DTDP.porao6, 0)) SOMA_POROES "

	Dim strSqlFrom
	strSqlFrom = " FROM "
	strSqlFrom = strSqlFrom & " sig_diariotrechodispatch DTD "
	strSqlFrom = strSqlFrom & " LEFT OUTER JOIN sig_tripulante TRP ON TRP.seqtripulante = DTD.seqtripulante "
	strSqlFrom = strSqlFrom & " LEFT OUTER JOIN sig_diariotrechodispatchporao DTDP ON DTDP.seqvoodia = DTD.seqvoodia AND DTDP.seqtrecho = DTD.seqtrecho "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_usuario USU ON USU.sequsuario = DTD.sequsuario "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_diariotrecho DT ON DT.seqvoodia = DTD.seqvoodia AND DT.seqtrecho = DTD.seqtrecho "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_frota Fr ON Fr.seqfrota = DT.seqfrota "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_aeroporto ApOrig ON ApOrig.seqaeroporto = DTD.seqaeroporig "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_aeroporto ApDest ON ApDest.seqaeroporto = DTD.seqaeropdest "
	strSqlFrom = strSqlFrom & " LEFT OUTER JOIN sig_aeronave Aeronave ON Aeronave.prefixored = DTD.prefixored "
	strSqlFrom = strSqlFrom & " LEFT OUTER JOIN sig_aeronavepbo AeronavePbo ON AeronavePbo.prefixo = Aeronave.prefixo AND AeronavePbo.crewconf = DTD.crewconf "
	strSqlFrom = strSqlFrom & " INNER JOIN sig_diariovoo DV ON DV.seqvoodia = DTD.seqvoodia, "
	strSqlFrom = strSqlFrom & " sig_parametros Param "

	Dim strSqlWhere
	strSqlWhere = " WHERE "
	strSqlWhere = strSqlWhere & "     DTD.seqvoodia = " & intSeqVooDia
	strSqlWhere = strSqlWhere & " AND DTD.seqtrecho = " & intSeqTrecho
	strSqlWhere = strSqlWhere & " AND DTD.numedicao = (SELECT MAX(DTD2.numedicao) FROM sig_diariotrechodispatch DTD2 "
	strSqlWhere = strSqlWhere & "                       WHERE DTD2.seqvoodia = DTD.seqvoodia "
	strSqlWhere = strSqlWhere & "                         AND DTD2.seqtrecho = DTD.seqtrecho "
	strSqlWhere = strSqlWhere & "                         AND UPPER(DTD2.flgpublicado) = 'S' ) "

	Dim strQuery
	strQuery = strSqlSelect & strSqlFrom & strSqlWhere

	Dim objRs
	Set objRs = Server.CreateObject("ADODB.Recordset")
	objRs.Open strQuery, objConn

	If (objRs.EOF) Then
		objRs.Close()
		Set objRs = Nothing
		objConn.Close()
		Set objConn = Nothing
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If

	strEdition = objRs("EDITION")

	strNomeGuerra = objRs("CAPTAIN")
	strCodDac = objRs("COD_DAC")
	If (Not IsVazio(strNomeGuerra)) Then
		strCaptain = strNomeGuerra & " - "
	Else
		strCaptain = " - "
	End If
	If (Not IsVazio(strCodDac)) Then strCaptain = strCaptain & strCodDac & " "

	Dim strUsuario, strCodAnac
	strUsuario = objRs("PREPARED_BY")
	strCodAnac = objRs("COD_ANAC")
	If (Not IsVazio(strUsuario)) Then
		strPreparedBy = strUsuario & " - "
	Else
		strPreparedBy = " - "
	End If
	If (Not IsVazio(strCodAnac)) Then strPreparedBy = strPreparedBy & strCodAnac & " "

	strFrota = objRs("FROTA")
	If (IsVazio(strFrota)) Then strFrota = "&nbsp;"

	strEngineRating = objRs("ENGINE_RATING")
	If (IsVazio(strEngineRating)) Then strEngineRating = "&nbsp;"

	strFlaps = objRs("FLAPS")
	If (IsVazio(strFlaps)) Then strFlaps = "&nbsp;"

	strStabTrim = objRs("STAB_TRIM")
	If (IsVazio(strStabTrim)) Then
		strStabTrim = "&nbsp;"
	Else
		strStabTrim = FormatNumber(strStabTrim, 1)
	End If

	strTotal = CLng(0)

	strCombMain1 = objRs("COMB_MAIN1")
	If (IsVazio(strCombMain1)) Then
		strCombMain1 = "&nbsp;"
	Else
		strTotal = strTotal + CLng(strCombMain1)
	End If

	strCombMain2 = objRs("COMB_MAIN2")
	If (IsVazio(strCombMain2)) Then
		strCombMain2 = "&nbsp;"
	Else
		strTotal = strTotal + CLng(strCombMain2)
	End If

	strCombCtr = objRs("COMB_CTR")
	If (IsVazio(strCombCtr)) Then
		strCombCtr = "&nbsp;"
	Else
		strTotal = strTotal + CLng(strCombCtr)
	End If

	strRemarks = objRs("REMARKS")
	If (IsVazio(strRemarks)) Then strRemarks = "&nbsp;"

	strBleeds = objRs("BLEEDS")
	If (IsVazio(strBleeds)) Then strBleeds = "&nbsp;"

	strWindDirection = objRs("WIND_DIRECTION")
	If (IsVazio(strWindDirection)) Then strWindDirection = "&nbsp;"

	strWind = objRs("WIND")
	If (IsVazio(strWind)) Then strWind = "&nbsp;"

	strTemperature = objRs("TEMPERATURE")
	If (IsVazio(strTemperature)) Then strTemperature = "&nbsp;"

	strQNH = objRs("QNH")
	If (IsVazio(strQNH)) Then strQNH = "&nbsp;"

	strRWY = objRs("RWY")
	If (IsVazio(strRWY)) Then strRWY = "&nbsp;"

	strElevation = objRs("ELEVATION")
	If (IsVazio(strElevation)) Then strElevation = "&nbsp;"

	strRwyLimitedTakeoff = objRs("RWY_LIMITED_TAKEOFF")
	If (IsVazio(strRwyLimitedTakeoff)) Then strRwyLimitedTakeoff = "&nbsp;"

	strClimbLimitedTakeoff = objRs("CLIMB_LIMITED_TAKEOFF")
	If (IsVazio(strClimbLimitedTakeoff)) Then strClimbLimitedTakeoff = "&nbsp;"

	strQnhCorrection = objRs("QNH_CORRECTION")
	If (IsVazio(strQnhCorrection)) Then strQnhCorrection = "&nbsp;"

	strRwyLimitedCorrectedMtow = objRs("RWY_LIMITED_CORRECTED_MTOW")
	If (IsVazio(strRwyLimitedCorrectedMtow)) Then strRwyLimitedCorrectedMtow = "&nbsp;"

	strRwnlw = objRs("RWNLW")
	If (IsVazio(strRwnlw)) Then strRwnlw = "&nbsp;"

	strClimbLimitedCorrectedMtow = objRs("CLIMB_LIMITED_CORRECTED_MTOW")
	If (IsVazio(strClimbLimitedCorrectedMtow)) Then strClimbLimitedCorrectedMtow = "&nbsp;"

	Dim intMaximumWeightForTakeoff
	strMaximumWeightForTakeoff = objRs("MAXIMUM_WEIGHT_FOR_TAKEOFF")
	If (IsVazio(strMaximumWeightForTakeoff)) Then
		strMaximumWeightForTakeoff = "&nbsp;"
		intMaximumWeightForTakeoff = CLng(0)
	Else
		intMaximumWeightForTakeoff = CLng(strMaximumWeightForTakeoff)
	End If

	strAeronaveMtogw = objRs("AERONAVE_MTOGW")
	If (IsVazio(strAeronaveMtogw)) Then strAeronaveMtogw = "&nbsp;"

	Dim intMrwTaxiOutFuel
	strMrwTaxiOutFuel = objRs("MRW_TAXI_OUT_FUEL")
	If (IsVazio(strMrwTaxiOutFuel)) Then
		strMrwTaxiOutFuel = "&nbsp;"
		intMrwTaxiOutFuel = CLng(0)
	Else
		intMrwTaxiOutFuel = CLng(strMrwTaxiOutFuel)
	End If

	Dim intMzfwTakeoffFuel
	strMzfwTakeoffFuel = objRs("MZFW_TAKEOFF_FUEL")
	If (IsVazio(strMzfwTakeoffFuel)) Then
		strMzfwTakeoffFuel = "&nbsp;"
		intMzfwTakeoffFuel = CLng(0)
	Else
		intMzfwTakeoffFuel = CLng(strMzfwTakeoffFuel)
	End If

	Dim intMlwTripFuel
	strMlwTripFuel = objRs("MLW_TRIP_FUEL")
	If (IsVazio(strMlwTripFuel)) Then
		strMlwTripFuel = "&nbsp;"
		intMlwTripFuel = CLng(0)
	Else
		intMlwTripFuel = CLng(strMlwTripFuel)
	End If

	strAllowedWeightForTakeoff = objRs("ALLOWED_WEIGHT_FOR_TAKEOFF")
	If (IsVazio(strAllowedWeightForTakeoff)) Then strAllowedWeightForTakeoff = "&nbsp;"

	strBasicOperatingWeight = objRs("BASIC_OPERATING_WEIGHT")
	If (IsVazio(strBasicOperatingWeight)) Then strBasicOperatingWeight = "&nbsp;"

	strAllowedTrafficLoad = objRs("ALLOWED_TRAFFIC_LOAD")
	If (IsVazio(strAllowedTrafficLoad)) Then strAllowedTrafficLoad = "&nbsp;"

	strMaximumRampWeight = objRs("MAXIMUM_RAMP_WEIGHT")
	If (IsVazio(strMaximumRampWeight)) Then strMaximumRampWeight = "&nbsp;"

	strTaxiOutFuel = objRs("TAXI_OUT_FUEL")
	If (IsVazio(strTaxiOutFuel)) Then strTaxiOutFuel = "&nbsp;"

	strMaximumZeroFuelWeight = objRs("MAXIMUM_ZERO_FUEL_WEIGHT")
	If (IsVazio(strMaximumZeroFuelWeight)) Then strMaximumZeroFuelWeight = "&nbsp;"

	intTakeoffFuel = CInt(objRs("TAKEOFF_FUEL"))

	strMaximumLandingWeight = objRs("MAXIMUM_LANDING_WEIGHT")
	If (IsVazio(strMaximumLandingWeight)) Then strMaximumLandingWeight = "&nbsp;"

	intTripFuel = CInt(objRs("TRIP_FUEL"))

	strMaximumFlightPlanWeight = objRs("MAXIMUM_FLIGHT_PLAN_WEIGHT")
	If (IsVazio(strMaximumFlightPlanWeight)) Then strMaximumFlightPlanWeight = "&nbsp;"

	dtDataAlteracao = objRs("DATA_ALTERACAO")
	If (IsVazio(dtDataAlteracao)) Then
		strDataAlteracao = "&nbsp;"
	Else
		strDataAlteracao = Right("00" & Day(dtDataAlteracao), 2) & "/" & Right("00" & Month(dtDataAlteracao), 2) & "/" & Year(dtDataAlteracao)
		strDataAlteracao = strDataAlteracao & "&nbsp;" & FormatDateTime(dtDataAlteracao, 4)
	End If

	dtDataDispatch = objRs("DATA_DISPATCH")
	If (IsVazio(dtDataDispatch)) Then
		strDataDispatch = "&nbsp;"
	Else
		strDataDispatch = Right("00" & Day(dtDataDispatch), 2) & "/" & Right("00" & Month(dtDataDispatch), 2) & "/" & Year(dtDataDispatch)
		strDataDispatch = strDataDispatch & "&nbsp;" & FormatDateTime(dtDataDispatch, 4)
	End If

	strSiglaEmpresa = objRs("SIGLA_EMPRESA")
	If (IsVazio(strSiglaEmpresa)) Then strSiglaEmpresa = "&nbsp;"

	strRouteOrigem = objRs("ROUTE_ORIGEM")
	If (IsVazio(strRouteOrigem)) Then strRouteOrigem = "&nbsp;"

	strRouteDestino = objRs("ROUTE_DESTINO")
	If (IsVazio(strRouteDestino)) Then strRouteDestino = "&nbsp;"

	Dim dtStdPartidaPlanej
	dtStdPartidaPlanej = objRs("STD_PARTIDA_PLANEJ")
	If (IsVazio(dtStdPartidaPlanej)) Then
		strStdPartidaPlanej = "&nbsp;"
	Else
		strStdPartidaPlanej = Right("00" & Day(dtStdPartidaPlanej), 2) & "/" & Right("00" & Month(dtStdPartidaPlanej), 2) & "/" & Year(dtStdPartidaPlanej)
		strStdPartidaPlanej = strStdPartidaPlanej & "<br />" & FormatDateTime(dtStdPartidaPlanej, 4)
	End If

	Dim dtStaChegadaPlanej
	dtStaChegadaPlanej = objRs("STA_CHEGADA_PLANEJ")
	If (IsVazio(dtStaChegadaPlanej)) Then
		strStaChegadaPlanej = "&nbsp;"
	Else
		strStaChegadaPlanej = Right("00" & Day(dtStaChegadaPlanej), 2) & "/" & Right("00" & Month(dtStaChegadaPlanej), 2) & "/" & Year(dtStaChegadaPlanej)
		strStaChegadaPlanej = strStaChegadaPlanej & "<br />" & FormatDateTime(dtStaChegadaPlanej, 4)
	End If

	strPboIndex = objRs("PBO_INDEX")
	If (IsVazio(strPboIndex)) Then
		strPboIndex = "&nbsp;"
	Else
		strPboIndex = FormatNumber(strPboIndex, 1)
	End If

	strAeronavePboArm = objRs("AERONAVE_PBO_ARM")
	If (IsVazio(strAeronavePboArm)) Then
		strAeronavePboArm = "&nbsp;"
	Else
		strAeronavePboArm = FormatNumber(strAeronavePboArm, 1)
	End If

	strCrewConf = objRs("CREW_CONF")
	If (IsVazio(strCrewConf)) Then strCrewConf = "&nbsp;"

	strFwdCargo = objRs("FWD_CARGO")
	If (IsVazio(strFwdCargo)) Then strFwdCargo = "&nbsp;"

	strAftCargo = objRs("AFT_CARGO")
	If (IsVazio(strAftCargo)) Then strAftCargo = "&nbsp;"

	strPaxAdt = objRs("PAX_ADT")
	If (IsVazio(strPaxAdt)) Then strPaxAdt = "&nbsp;"

	strPaxChd = objRs("PAX_CHD")
	If (IsVazio(strPaxChd)) Then strPaxChd = "&nbsp;"

	strPaxInf = objRs("PAX_INF")
	If (IsVazio(strPaxInf)) Then strPaxInf = "&nbsp;"

	strZeroFuelWeight = objRs("ZERO_FUEL_WEIGHT")
	If (IsVazio(strZeroFuelWeight)) Then strZeroFuelWeight = "&nbsp;"

	strZfwIndex = objRs("ZFW_INDEX")
	If (IsVazio(strZfwIndex)) Then
		strZfwIndex = "&nbsp;"
	Else
		strZfwIndex = FormatNumber(strZfwIndex, 1)
	End If

	strTakeoffWeight = objRs("TAKEOFF_WEIGHT")
	If (IsVazio(strTakeoffWeight)) Then strTakeoffWeight = "&nbsp;"

	strTowIndex = objRs("TOW_INDEX")
	If (IsVazio(strTowIndex)) Then
		strTowIndex = "&nbsp;"
	Else
		strTowIndex = FormatNumber(strTowIndex, 1)
	End If

	strLandingWeight = objRs("LANDING_WEIGHT")
	If (IsVazio(strLandingWeight)) Then strLandingWeight = "&nbsp;"

	strLwIndex = objRs("LW_INDEX")
	If (IsVazio(strLwIndex)) Then
		strLwIndex = "&nbsp;"
	Else
		strLwIndex = FormatNumber(strLwIndex, 1)
	End If

	strActualUnderload = objRs("ACTUAL_UNDERLOAD")
	If (IsVazio(strActualUnderload)) Then strActualUnderload = "&nbsp;"

	strNrVoo = objRs("NR_VOO")
	If (IsVazio(strNrVoo)) Then strNrVoo = "&nbsp;"

	Dim menorValor
	menorValor = CLng(intMaximumWeightForTakeoff)
	strRestrictBy = "TAKEOFF&nbsp;WEIGHT"
	If (intMrwTaxiOutFuel < menorValor) Then
		menorValor = CLng(intMrwTaxiOutFuel)
		strRestrictBy = "RAMP&nbsp;WEIGHT"
	End If
	If (intMzfwTakeoffFuel < menorValor) Then
		menorValor = CLng(intMzfwTakeoffFuel)
		strRestrictBy = "ZERO&nbsp;FUEL&nbsp;WEIGHT"
	End If
	If (intMlwTripFuel < menorValor) Then
		menorValor = CLng(intMlwTripFuel)
		strRestrictBy = "LANDING&nbsp;WEIGHT"
	End If

	intBagCargaCorreio = CInt(objRs("BAG_CARGA_CORREIO"))
	intSomaPoroes = CInt(objRs("SOMA_POROES"))

	'********************************
	'***  CARREGAMENTO DE POROES  ***
	'********************************
	strCarregChegPorao1 = objRs("CARREG_CHEG_PORAO1")
	If (IsVazio(strCarregChegPorao1)) Then strCarregChegPorao1 = "&nbsp;"
	strCarregChegPorao1 = FormataTextoBD(strCarregChegPorao1)

	strCarregChegPorao2 = objRs("CARREG_CHEG_PORAO2")
	If (IsVazio(strCarregChegPorao2)) Then strCarregChegPorao2 = "&nbsp;"
	strCarregChegPorao2 = FormataTextoBD(strCarregChegPorao2)

	strCarregChegPorao3 = objRs("CARREG_CHEG_PORAO3")
	If (IsVazio(strCarregChegPorao3)) Then strCarregChegPorao3 = "&nbsp;"
	strCarregChegPorao3 = FormataTextoBD(strCarregChegPorao3)

	strCarregChegPorao4 = objRs("CARREG_CHEG_PORAO4")
	If (IsVazio(strCarregChegPorao4)) Then strCarregChegPorao4 = "&nbsp;"
	strCarregChegPorao4 = FormataTextoBD(strCarregChegPorao4)

	strCarregPartPorao1 = objRs("CARREG_PART_PORAO1")
	If (IsVazio(strCarregPartPorao1)) Then strCarregPartPorao1 = "&nbsp;"
	strCarregPartPorao1 = FormataTextoBD(strCarregPartPorao1)

	strCarregPartPorao2 = objRs("CARREG_PART_PORAO2")
	If (IsVazio(strCarregPartPorao2)) Then strCarregPartPorao2 = "&nbsp;"
	strCarregPartPorao2 = FormataTextoBD(strCarregPartPorao2)

	strCarregPartPorao3 = objRs("CARREG_PART_PORAO3")
	If (IsVazio(strCarregPartPorao3)) Then strCarregPartPorao3 = "&nbsp;"
	strCarregPartPorao3 = FormataTextoBD(strCarregPartPorao3)

	strCarregPartPorao4 = objRs("CARREG_PART_PORAO4")
	If (IsVazio(strCarregPartPorao4)) Then strCarregPartPorao4 = "&nbsp;"
	strCarregPartPorao4 = FormataTextoBD(strCarregPartPorao4)

	strCarregInstrucao = objRs("CARREG_INSTRUCAO")
	If (IsVazio(strCarregInstrucao)) Then strCarregInstrucao = "&nbsp;"
	strCarregInstrucao = FormataTextoBD(strCarregInstrucao)

	strRwyCondition = objRs("RWY_CONDITION")
	If (IsVazio(strRwyCondition)) Then strRwyCondition = "&nbsp;"
	strRwyCondition = FormataTextoBD(strRwyCondition)

	strTakeOffMode = objRs("TAKE_OFF_MODE")
	If (IsVazio(strTakeOffMode)) Then strTakeOffMode = "&nbsp;"
	strTakeOffMode = FormataTextoBD(strTakeOffMode)


	'**********************
	'***  PLANO DE VOO  ***
	'**********************
	strPlanoVoo = objRs("PLANO_VOO")
	If (IsVazio(strPlanoVoo)) Then strPlanoVoo = "&nbsp;"
	strPlanoVoo = FormataTextoBD(strPlanoVoo)

	'**************************
	'***  PREFIXO AERONAVE  ***
	'**************************
	strPrefixoAeronave = objRs("PREFIXO_AERONAVE")



	' *****************
	' *** PAX SECAO ***
	' *****************
	Dim strQueryPaxSecao
	strQueryPaxSecao =                    " SELECT SUM(SDTDS.paxadt) PAX_ADT_SOMA, SUM(SDTDS.paxchd) PAX_CHD_SOMA, SUM(SDTDS.paxinf) PAX_INF_SOMA, "
	strQueryPaxSecao = strQueryPaxSecao & "        SUM(SDTDS.paxpad) PAX_PAD_SOMA, SUM(SDTDS.paxdhc) PAX_DHC_SOMA "
	strQueryPaxSecao = strQueryPaxSecao & " FROM sig_diariotrechodispatchsecao SDTDS "
	strQueryPaxSecao = strQueryPaxSecao & " WHERE SDTDS.seqvoodia = " & intSeqVooDia
	strQueryPaxSecao = strQueryPaxSecao & "   AND SDTDS.seqtrecho = " & intSeqTrecho

	Dim objRsPaxSecao
	Set objRsPaxSecao = Server.CreateObject("ADODB.Recordset")
	objRsPaxSecao.Open strQueryPaxSecao, objConn

	intPaxPesoTotal = CInt(0)
	If (Not objRsPaxSecao.EOF) Then
		Dim intPaxAdtSomaSecoes, intPaxChdSomaSecoes, intPaxInfSomaSecoes
		intPaxAdtSomaSecoes = objRsPaxSecao("PAX_ADT_SOMA")
		If (IsVazio(intPaxAdtSomaSecoes)) Then
			intPaxAdtSomaSecoes = CInt(0)
		End If
		intPaxChdSomaSecoes = objRsPaxSecao("PAX_CHD_SOMA")
		If (IsVazio(intPaxChdSomaSecoes)) Then
			intPaxChdSomaSecoes = CInt(0)
		End If
		intPaxInfSomaSecoes = objRsPaxSecao("PAX_INF_SOMA")
		If (IsVazio(intPaxInfSomaSecoes)) Then
			intPaxInfSomaSecoes = CInt(0)
		End If

		Dim intPaxPadSomaSecoes, intPaxDhcSomaSecoes
		intPaxPadSomaSecoes = objRsPaxSecao("PAX_PAD_SOMA")
		If (IsVazio(intPaxPadSomaSecoes)) Then
			intPaxPadSomaSecoes = CInt(0)
		End If
		intPaxDhcSomaSecoes = objRsPaxSecao("PAX_DHC_SOMA")
		If (IsVazio(intPaxDhcSomaSecoes)) Then
			intPaxDhcSomaSecoes = CInt(0)
		End If
    
	    pesoAdulto = objRs("PESOADT")
        If (IsVazio(pesoAdulto)) Then
			pesoAdulto = 80
		End If

	    pesoCrianca = objRs("PESOCHD")
        If (IsVazio(pesoCrianca)) Then
			pesoCrianca = 35
		End If

	    pesoInfo = objRs("PESOINF")
        If (IsVazio(pesoInfo)) Then
			pesoInfo = 10
		End If

		intPaxPesoTotal = (CInt(pesoAdulto) * CInt(CInt(intPaxAdtSomaSecoes) + CInt(intPaxPadSomaSecoes) + CInt(intPaxDhcSomaSecoes))) + (CInt(pesoCrianca) * CInt(intPaxChdSomaSecoes)) + (CInt(pesoInfo) * CInt(intPaxInfSomaSecoes))
	End If


	objRsPaxSecao.Close()
	Set objRsPaxSecao = Nothing

	objRs.Close()
	Set objRs = Nothing

	objConn.Close()
	Set objConn = Nothing

End Sub

Sub MontarTabelaSecaoFileira()

	Dim objConnSecaoFileira
	Set objConnSecaoFileira = CreateObject("ADODB.CONNECTION")
	objConnSecaoFileira.ConnectionTimeout = 120
	objConnSecaoFileira.Open (StringConexaoSqlServer)
	objConnSecaoFileira.Execute "SET DATEFORMAT ymd"

	' *****************
	' *** SECAO ARM ***
	' *****************
	Dim strQuerySecaoArm
	strQuerySecaoArm =                    " SELECT SSA.secao, SSA.arm, SSA.capac_pax, SSA.fileiraini, SSA.fileirafim "
	strQuerySecaoArm = strQuerySecaoArm & " FROM sig_secaoarm SSA "
	strQuerySecaoArm = strQuerySecaoArm & " WHERE SSA.prefixo = '" & strPrefixoAeronave & "' "
	strQuerySecaoArm = strQuerySecaoArm & " ORDER BY SSA.secao ASC "

	Dim objRsSecaoArm
	Set objRsSecaoArm = Server.CreateObject("ADODB.Recordset")
	objRsSecaoArm.Open strQuerySecaoArm, objConnSecaoFileira

	Dim blnEscreveuPrimeiraLinha
	blnEscreveuPrimeiraLinha = False

	Do While (Not objRsSecaoArm.EOF)
		Dim intSecaoSSA, intFileiraIni, intFileiraFim
		intSecaoSSA = CInt(objRsSecaoArm("secao"))
		intFileiraIni = objRsSecaoArm("fileiraini")
		intFileiraFim = objRsSecaoArm("fileirafim")

		objRsSecaoArm.MoveNext()

		If ((Not IsVazio(intFileiraIni)) And (Not IsVazio(intFileiraFim))) Then
			If (Not blnEscreveuPrimeiraLinha)Then
				Response.Write("<table class='tabelaComBordas' cellpadding='0' cellspacing='0' style='text-align:left; font-family:Verdana,Arial,Sans-Serif;'>" & vbCrLf)
			End If
			Response.Write("	<tr>" & vbCrLf)
			If (Not blnEscreveuPrimeiraLinha)Then
				Response.Write("		<td style='white-space:nowrap; font-size:6pt; border:none; padding:5px 10px 0 10px;'>Setor&nbsp;")
			ElseIf (objRsSecaoArm.EOF) Then
				Response.Write("		<td style='white-space:nowrap; font-size:6pt; border:none; padding:0 10px 5px 10px;'>Setor&nbsp;")
			Else
				Response.Write("		<td style='white-space:nowrap; font-size:6pt; border:none; padding:0 10px 0 10px;'>Setor&nbsp;")
			End If
			Response.Write(Chr(64 + intSecaoSSA) & "&nbsp;-&nbsp;Fileiras&nbsp;" & intFileiraIni & "&nbsp;a&nbsp;" & intFileiraFim & "</td>" & vbCrLf)
			Response.Write("	</tr>" & vbCrLf)
			blnEscreveuPrimeiraLinha = True
		End If
	Loop

	If (blnEscreveuPrimeiraLinha) Then
		Response.Write("</table>" & vbCrLf)
	End If

	objRsSecaoArm.Close()
	Set objRsSecaoArm = Nothing

	objConnSecaoFileira.Close()
	Set objConnSecaoFileira = Nothing

End Sub

Sub PreencherTabelaPaxSecao()

	Dim intSeqVooDiaPaxSecao, intSeqTrechoPaxSecao
	intSeqVooDiaPaxSecao = Request.QueryString("seqvoodia")
	intSeqTrechoPaxSecao = Request.QueryString("seqtrecho")

	If (IsVazio(intSeqVooDiaPaxSecao) Or IsVazio(intSeqTrechoPaxSecao)) Then
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If

	Dim objConnPaxSecao
	Set objConnPaxSecao = CreateObject("ADODB.CONNECTION")
	objConnPaxSecao.ConnectionTimeout = 120
	objConnPaxSecao.CommandTimeout = 120
	objConnPaxSecao.Open (StringConexaoSqlServer)
	objConnPaxSecao.Execute "SET DATEFORMAT ymd"

	' *****************************************
	' **********     PASSAGEIROS     **********
	' *****************************************

	' *****************
	' *** PAX SECAO ***
	' *****************
	Dim strQueryPaxSecao
	strQueryPaxSecao =                    " SELECT SDTDS.secao, SDTDS.paxadt, SDTDS.paxchd, SDTDS.paxinf, "
	strQueryPaxSecao = strQueryPaxSecao & "        SDTDS.paxpad, SDTDS.paxdhc "
	strQueryPaxSecao = strQueryPaxSecao & " FROM sig_diariotrechodispatchsecao SDTDS "
	strQueryPaxSecao = strQueryPaxSecao & " WHERE SDTDS.seqvoodia = " & intSeqVooDiaPaxSecao
	strQueryPaxSecao = strQueryPaxSecao & "   AND SDTDS.seqtrecho = " & intSeqTrechoPaxSecao
	strQueryPaxSecao = strQueryPaxSecao & " ORDER BY SDTDS.secao ASC "

	Dim objRsPaxSecao
	Set objRsPaxSecao = Server.CreateObject("ADODB.Recordset")
	objRsPaxSecao.Open strQueryPaxSecao, objConnPaxSecao

	' *****************
	' *** SECAO ARM ***
	' *****************
	Dim strQuerySecaoArm
	strQuerySecaoArm =                    " SELECT SSA.secao, SSA.arm, SSA.capac_pax "
	strQuerySecaoArm = strQuerySecaoArm & " FROM sig_secaoarm SSA "
	strQuerySecaoArm = strQuerySecaoArm & " WHERE SSA.prefixo = '" & strPrefixoAeronave & "' "
	strQuerySecaoArm = strQuerySecaoArm & " ORDER BY SSA.secao ASC "

	Dim objRsSecaoArm
	Set objRsSecaoArm = Server.CreateObject("ADODB.Recordset")
	objRsSecaoArm.Open strQuerySecaoArm, objConnPaxSecao

	Dim intPaxAdtTotal, intPaxChdTotal, intPaxInfTotal
	intPaxAdtTotal = CInt(0)
	intPaxChdTotal = CInt(0)
	intPaxInfTotal = CInt(0)

	' ************************
	' *** MONTA TABELA PAX ***
	' ************************
	Do While ((Not objRsPaxSecao.EOF) Or (Not objRsSecaoArm.EOF))

		Dim intSecaoSDTDS
		If (Not objRsPaxSecao.EOF) Then
			intSecaoSDTDS = CInt(objRsPaxSecao("secao"))
		End If

		Dim intSecaoSSA
		If (Not objRsSecaoArm.EOF) Then
			intSecaoSSA = CInt(objRsSecaoArm("secao"))
		End If

		Dim intSecao
		Dim intPaxAdt, intPaxChd, intPaxInf
		intPaxAdt = "&nbsp;"
		intPaxChd = "&nbsp;"
		intPaxInf = "&nbsp;"
		If (Not objRsPaxSecao.EOF) Then
			If (IsVazio(intSecaoSSA) Or (intSecaoSDTDS <= intSecaoSSA)) Then
				intSecao = intSecaoSDTDS
				intPaxAdt = CInt(objRsPaxSecao("paxadt")) + CInt(objRsPaxSecao("paxpad")) + CInt(objRsPaxSecao("paxdhc"))
				intPaxChd = CInt(objRsPaxSecao("paxchd"))
				intPaxInf = CInt(objRsPaxSecao("paxinf"))
				intPaxAdtTotal = intPaxAdtTotal + intPaxAdt
				intPaxChdTotal = intPaxChdTotal + intPaxChd
				intPaxInfTotal = intPaxInfTotal + intPaxInf
				objRsPaxSecao.MoveNext()
			End If
		End If

		Dim dblArmSecao, intCapacPax
		dblArmSecao = "&nbsp;"
		intCapacPax = "&nbsp;"
		If (Not objRsSecaoArm.EOF) Then
			If (IsVazio(intSecaoSDTDS) Or (intSecaoSDTDS >= intSecaoSSA)) Then
				intSecao = intSecaoSSA
				dblArmSecao = FormatNumber(CDbl(objRsSecaoArm("arm")), 1)
				intCapacPax = CInt(objRsSecaoArm("capac_pax"))
				objRsSecaoArm.MoveNext()
			End If
		End If

		Response.Write("<tr>" & vbCrLf)
		Response.Write("	<td style='font-size:7pt; text-align:left; padding-left:5px;'>" & Chr(64 + intSecao) & "&nbsp;(" & intCapacPax & "max)</td>" & vbCrLf)
		Response.Write("	<td style='font-size:7pt;'>" & dblArmSecao & "</td>" & vbCrLf)
		Response.Write("	<td style='font-size:7pt; background-color:#99FFFF;'>&nbsp;</td>" & vbCrLf)
		Response.Write("	<td style='font-size:7pt; background-color:#99FFFF;'>&nbsp;</td>" & vbCrLf)
		Response.Write("	<td style='font-size:7pt; background-color:#A9A9A9;'>" & intPaxAdt & "</td>" & vbCrLf)
		Response.Write("	<td style='font-size:7pt; background-color:#A9A9A9;'>" & intPaxChd & "</td>" & vbCrLf)
		Response.Write("	<td style='font-size:7pt; background-color:#A9A9A9;'>" & intPaxInf & "</td>" & vbCrLf)
		Response.Write("</tr>" & vbCrLf)
	Loop

	objRsPaxSecao.Close()
	Set objRsPaxSecao = Nothing

	objRsSecaoArm.Close()
	Set objRsSecaoArm = Nothing

	' *********************
	' *** TOTAL PARCIAL ***
	' *********************
	Response.Write("<tr>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt; text-align:left; padding-left:5px;'>Total</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt; background-color:#333333;'>////</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt; background-color:#99FFFF;'>&nbsp;</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt; background-color:#99FFFF;'>&nbsp;</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt;'>" & intPaxAdtTotal & "</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt;'>" & intPaxChdTotal & "</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt;'>" & intPaxInfTotal & "</td>" & vbCrLf)
	Response.Write("</tr>" & vbCrLf)

	' *******************
	' *** TOTAL GERAL ***
	' *******************
	Dim intPaxTotalGeral
	intPaxTotalGeral = CInt(CInt(intPaxAdtTotal) + CInt(intPaxChdTotal) + CInt(intPaxInfTotal))
	Response.Write("<tr>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt; text-align:left; padding-left:5px;'>Total&nbsp;Geral</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt; background-color:#333333;'>////</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt; background-color:#99FFFF;'>&nbsp;</td>" & vbCrLf)
	Response.Write("	<td style='font-size:7pt; background-color:#99FFFF;'>&nbsp;</td>" & vbCrLf)
	Response.Write("	<td colspan='3' style='font-size:7pt;'>" & intPaxTotalGeral & "</td>" & vbCrLf)
	Response.Write("</tr>" & vbCrLf)

	' *********************************************************************************

	' ***********************************
	' **********     PORAO     **********
	' ***********************************

	' *************
	' *** PORAO ***
	' *************
	Dim strQueryPorao
	strQueryPorao =                 " SELECT SDTDP.porao1, SDTDP.porao2, SDTDP.porao3, SDTDP.porao4, SDTDP.porao5, SDTDP.porao6 "
	strQueryPorao = strQueryPorao & " FROM sig_diariotrechodispatchporao SDTDP "
	strQueryPorao = strQueryPorao & " WHERE SDTDP.seqvoodia = " & intSeqVooDiaPaxSecao
	strQueryPorao = strQueryPorao & "   AND SDTDP.seqtrecho = " & intSeqTrechoPaxSecao

	Dim objRsPorao
	Set objRsPorao = Server.CreateObject("ADODB.Recordset")
	objRsPorao.Open strQueryPorao, objConnPaxSecao

	' *****************
	' *** PORAO ARM ***
	' *****************
	Dim strQueryPoraoArm
	strQueryPoraoArm =                    " SELECT SA.flgporao1, SA.flgporao2, SA.flgporao3, SA.flgporao4, SA.flgporao5, SA.flgporao6, "
	strQueryPoraoArm = strQueryPoraoArm & "        SA.armporao1, SA.armporao2, SA.armporao3, SA.armporao4, SA.armporao5, SA.armporao6 "
	strQueryPoraoArm = strQueryPoraoArm & " FROM sig_aeronave SA "
	strQueryPoraoArm = strQueryPoraoArm & " WHERE SA.prefixo = '" & strPrefixoAeronave & "' "

	Dim objRsPoraoArm
	Set objRsPoraoArm = Server.CreateObject("ADODB.Recordset")
	objRsPoraoArm.Open strQueryPoraoArm, objConnPaxSecao

	' **************************
	' *** MONTA TABELA PORAO ***
	' **************************
	If (Not objRsPoraoArm.EOF) Then
		Dim i
		For i = 1 To 6
			Dim strFlgPorao
			strFlgPorao = objRsPoraoArm("flgporao" & i)
			If ((strFlgPorao = "S") Or (strFlgPorao = "s")) Then
				Dim intPesoPorao
				intPesoPorao = "&nbsp;"
				If (Not objRsPorao.EOF and Not IsVazio(objRsPorao("porao" & i))) Then
					intPesoPorao = CInt(objRsPorao("porao" & i))
				End If
				Dim dblArmPorao
				dblArmPorao = objRsPoraoArm("armporao" & i)
				If (Not IsVazio(dblArmPorao)) Then dblArmPorao = FormatNumber(dblArmPorao, 1)
				Response.Write("<tr>" & vbCrLf)
				Response.Write("	<td style='font-size:7pt; text-align:left; padding-left:5px;'>Por&atilde;o&nbsp;" & i & "</td>" & vbCrLf)
				Response.Write("	<td style='font-size:7pt;'>" & dblArmPorao & "</td>" & vbCrLf)
				Response.Write("	<td style='font-size:7pt; background-color:#99FFFF;'>&nbsp;</td>" & vbCrLf)
				Response.Write("	<td style='font-size:7pt; background-color:#99FFFF;'>&nbsp;</td>" & vbCrLf)
				Response.Write("	<td colspan='3' style='font-size:7pt;'>" & intPesoPorao & "</td>" & vbCrLf)
				Response.Write("</tr>" & vbCrLf)
			End If
		Next
	End If

	objRsPoraoArm.Close()
	Set objRsPoraoArm = Nothing

	objConnPaxSecao.Close()
	Set objConnPaxSecao = Nothing

End Sub

	Dim dblCAP00TowIndex, intCAP00PaxMax
	Dim dblCAP05TowIndex, intCAP05PaxMax
	Dim dblCAP10TowIndex, intCAP10PaxMax
	Dim dblCAP15TowIndex, intCAP15PaxMax
	Dim dblCAP20TowIndex, intCAP20PaxMax
	Dim dblCAR05TowIndex
	Dim dblCAR10TowIndex
	Dim dblCAR15TowIndex
	Dim dblCAR20TowIndex
	Dim dblFCP10TowIndex, intFCP10PaxMax
	Dim dblFCP20TowIndex, intFCP20PaxMax
	Dim dblFCP30TowIndex, intFCP30PaxMax
	Dim dblFCP40TowIndex, intFCP40PaxMax
	Dim dblFCP50TowIndex, intFCP50PaxMax
	Dim dblFUE10TowIndex
	Dim dblFUE20TowIndex
	Dim dblFUE30TowIndex
	Dim dblFUE40TowIndex
	Dim dblFUE50TowIndex
	Dim dblFUP10TowIndex, intFUP10PaxMax
	Dim dblFUP20TowIndex, intFUP20PaxMax
	Dim dblFUP30TowIndex, intFUP30PaxMax
	Dim dblFUP40TowIndex, intFUP40PaxMax
	Dim dblFUP50TowIndex, intFUP50PaxMax
	Dim dblPAX01TowIndex
	Dim dblPAX02TowIndex
	Dim dblPAX03TowIndex
	Dim dblPAX04TowIndex
	Dim dblPAX05TowIndex

	dblCAP00TowIndex = "UNB"
	intCAP00PaxMax = "UNB"
	dblCAP05TowIndex = "UNB"
	intCAP05PaxMax = "UNB"
	dblCAP10TowIndex = "UNB"
	intCAP10PaxMax = "UNB"
	dblCAP15TowIndex = "UNB"
	intCAP15PaxMax = "UNB"
	dblCAP20TowIndex = "UNB"
	intCAP20PaxMax = "UNB"
	dblCAR05TowIndex = "UNB"
	dblCAR10TowIndex = "UNB"
	dblCAR15TowIndex = "UNB"
	dblCAR20TowIndex = "UNB"
	dblFCP10TowIndex = "UNB"
	intFCP10PaxMax = "UNB"
	dblFCP20TowIndex = "UNB"
	intFCP20PaxMax = "UNB"
	dblFCP30TowIndex = "UNB"
	intFCP30PaxMax = "UNB"
	dblFCP40TowIndex = "UNB"
	intFCP40PaxMax = "UNB"
	dblFCP50TowIndex = "UNB"
	intFCP50PaxMax = "UNB"
	dblFUE10TowIndex = "UNB"
	dblFUE20TowIndex = "UNB"
	dblFUE30TowIndex = "UNB"
	dblFUE40TowIndex = "UNB"
	dblFUE50TowIndex = "UNB"
	dblFUP10TowIndex = "UNB"
	intFUP10PaxMax = "UNB"
	dblFUP20TowIndex = "UNB"
	intFUP20PaxMax = "UNB"
	dblFUP30TowIndex = "UNB"
	intFUP30PaxMax = "UNB"
	dblFUP40TowIndex = "UNB"
	intFUP40PaxMax = "UNB"
	dblFUP50TowIndex = "UNB"
	intFUP50PaxMax = "UNB"
	dblPAX01TowIndex = "UNB"
	dblPAX02TowIndex = "UNB"
	dblPAX03TowIndex = "UNB"
	dblPAX04TowIndex = "UNB"
	dblPAX05TowIndex = "UNB"

Sub PreencherDadosLMC()

	intSeqVooDia = Request.QueryString("seqvoodia")
	intSeqTrecho = Request.QueryString("seqtrecho")

	Dim objConnLMC
	Set objConnLMC = CreateObject("ADODB.CONNECTION")
	objConnLMC.ConnectionTimeout = 120
	objConnLMC.Open (StringConexaoSqlServer)
	objConnLMC.Execute "SET DATEFORMAT ymd"

	' ***********
	' *** LMC ***
	' ***********
	Dim strQueryLMC
	strQueryLMC =               " SELECT DTDLMC.configuracao, DTDLMC.towindex, DTDLMC.paxmax "
	strQueryLMC = strQueryLMC & " FROM sig_diariotrechodispatchlmc DTDLMC "
	strQueryLMC = strQueryLMC & " WHERE DTDLMC.seqvoodia = " & intSeqVooDia
	strQueryLMC = strQueryLMC & "   AND DTDLMC.seqtrecho = " & intSeqTrecho
	strQueryLMC = strQueryLMC & "   AND DTDLMC.numedicao = '" & strEdition & "' "
	strQueryLMC = strQueryLMC & " ORDER BY DTDLMC.configuracao ASC "

	Dim objRsLMC
	Set objRsLMC = Server.CreateObject("ADODB.Recordset")
	objRsLMC.Open strQueryLMC, objConnLMC

	Do While (Not objRsLMC.EOF)
		Dim strConfiguracaoLMC
		strConfiguracaoLMC = objRsLMC("configuracao")

		If (Not IsVazio(strConfiguracaoLMC)) Then
			strConfiguracaoLMC = UCase(strConfiguracaoLMC)

			Dim dblTowIndexLMC, intPaxMaxLMC
			dblTowIndexLMC = objRsLMC("towindex")
			intPaxMaxLMC = objRsLMC("paxmax")

			Select Case strConfiguracaoLMC
				Case "CAP00"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAP00TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intCAP00PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "CAP05"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAP05TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intCAP05PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "CAP10"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAP10TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intCAP10PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "CAP15"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAP15TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intCAP15PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "CAP20"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAP20TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intCAP20PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "CAR05"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAR05TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "CAR10"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAR10TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "CAR15"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAR15TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "CAR20"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblCAR20TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "FCP10"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFCP10TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFCP10PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FCP20"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFCP20TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFCP20PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FCP30"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFCP30TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFCP30PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FCP40"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFCP40TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFCP40PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FCP50"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFCP50TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFCP50PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FUE10"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUE10TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "FUE20"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUE20TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "FUE30"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUE30TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "FUE40"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUE40TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "FUE50"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUE50TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "FUP10"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUP10TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFUP10PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FUP20"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUP20TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFUP20PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FUP30"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUP30TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFUP30PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FUP40"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUP40TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFUP40PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "FUP50"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblFUP50TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
					If (Not IsVazio(intPaxMaxLMC)) Then
						intFUP50PaxMax = CInt(intPaxMaxLMC)
					End If
				Case "PAX01"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblPAX01TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "PAX02"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblPAX02TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "PAX03"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblPAX03TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "PAX04"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblPAX04TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
				Case "PAX05"
					If (Not IsVazio(dblTowIndexLMC)) Then
						dblTowIndexLMC = CDbl(dblTowIndexLMC)
						If (dblTowIndexLMC >= 0.0) Then
							dblPAX05TowIndex = FormatNumber(dblTowIndexLMC, 1)
						End If
					End If
			End Select
		End If

		objRsLMC.MoveNext()
	Loop

	objRsLMC.Close()
	Set objRsLMC = Nothing

	objConnLMC.Close()
	Set objConnLMC = Nothing

End Sub

Sub PreencherTabelaCombinada()

	Dim intSeqVooDiaComb, intSeqTrechoComb
	intSeqVooDiaComb = Request.QueryString("seqvoodia")
	intSeqTrechoComb = Request.QueryString("seqtrecho")

	If (IsVazio(intSeqVooDiaComb) Or IsVazio(intSeqTrechoComb)) Then
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If

	Dim objConnComb
	Set objConnComb = CreateObject("ADODB.CONNECTION")
	objConnComb.Open (StringConexaoSqlServer)
	objConnComb.Execute "SET DATEFORMAT ymd"

	' *****************
	' *** COMBINADA ***
	' *****************
	Dim strQueryComb
	strQueryComb =                " SELECT MAX(DTC2.seqcombinada) ORDEM, "
	strQueryComb = strQueryComb & "        ApDest.codiata DESTINO_COMB, "
	strQueryComb = strQueryComb & "        'T' TIPO_EMBARQUE, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxprimeira, 0) + COALESCE(DTC.paxprimeiratran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxespecial, 0) + COALESCE(DTC.paxespecialtran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxeconomica, 0) + COALESCE(DTC.paxeconomicatran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxturismo, 0) + COALESCE(DTC.paxturismotran, 0) - "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxchd, 0) - COALESCE(DTC.paxchdtran, 0)) PAX_ADT, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxchd, 0) + COALESCE(DTC.paxchdtran, 0)) PAX_CHD, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxinf, 0) + COALESCE(DTC.paxinftran, 0)) PAX_INF, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.baglivre, 0) + COALESCE(DTC.baglivretran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.bagexcesso, 0) + COALESCE(DTC.bagexcessotran, 0)) PESO_BAGAGEM, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.cargapaga, 0) + COALESCE(DTC.cargapagatran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.cargagratis, 0) + COALESCE(DTC.cargagratistran, 0)) PESO_CARGA "
	strQueryComb = strQueryComb & " FROM sig_diariotrechocomb DTC "
	strQueryComb = strQueryComb & "      INNER JOIN sig_diariotrechocomb DTC2 ON DTC.seqvoodia = DTC2.seqvoodia "
	strQueryComb = strQueryComb & "                                          AND DTC.seqaeropdest = DTC2.seqaeropdest "
	strQueryComb = strQueryComb & "                                          AND DTC2.seqtrecho = " & intSeqTrechoComb
	strQueryComb = strQueryComb & "      INNER JOIN sig_diariotrecho DT ON DTC.seqvoodia = DT.seqvoodia "
	strQueryComb = strQueryComb & "                                    AND DTC.seqtrecho = DT.seqtrecho "
	strQueryComb = strQueryComb & "      INNER JOIN sig_diariotrecho DT2 ON DTC.seqvoodia = DT2.seqvoodia "
	strQueryComb = strQueryComb & "                                     AND DTC.seqaeropdest = DT2.seqaeropdest "
	strQueryComb = strQueryComb & "      INNER JOIN sig_aeroporto ApDest ON DTC.seqaeropdest = ApDest.seqaeroporto "
	strQueryComb = strQueryComb & " WHERE DTC.seqvoodia = " & intSeqVooDiaComb
	strQueryComb = strQueryComb & "   AND DTC.seqtrecho < " & intSeqTrechoComb
	strQueryComb = strQueryComb & "   AND DT2.seqtrecho >= " & intSeqTrechoComb
	strQueryComb = strQueryComb & " GROUP BY ApDest.codiata "
	strQueryComb = strQueryComb & " UNION "
	strQueryComb = strQueryComb & " SELECT MAX(DTC.seqcombinada) ORDEM, "
	strQueryComb = strQueryComb & "        ApDest.codiata DESTINO_COMB, "
	strQueryComb = strQueryComb & "        'L' TIPO_EMBARQUE, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxprimeira, 0) + COALESCE(DTC.paxprimeiratran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxespecial, 0) + COALESCE(DTC.paxespecialtran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxeconomica, 0) + COALESCE(DTC.paxeconomicatran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxturismo, 0) + COALESCE(DTC.paxturismotran, 0) - "
	strQueryComb = strQueryComb & "            COALESCE(DTC.paxchd, 0) - COALESCE(DTC.paxchdtran, 0)) PAX_ADT, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxchd, 0) + COALESCE(DTC.paxchdtran, 0)) PAX_CHD, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.paxinf, 0) + COALESCE(DTC.paxinftran, 0)) PAX_INF, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.baglivre, 0) + COALESCE(DTC.baglivretran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.bagexcesso, 0) + COALESCE(DTC.bagexcessotran, 0)) PESO_BAGAGEM, "
	strQueryComb = strQueryComb & "        SUM(COALESCE(DTC.cargapaga, 0) + COALESCE(DTC.cargapagatran, 0) + "
	strQueryComb = strQueryComb & "            COALESCE(DTC.cargagratis, 0) + COALESCE(DTC.cargagratistran, 0)) PESO_CARGA "
	strQueryComb = strQueryComb & " FROM sig_diariotrechocomb DTC "
	strQueryComb = strQueryComb & "      INNER JOIN sig_aeroporto ApDest ON DTC.seqaeropdest = ApDest.seqaeroporto "
	strQueryComb = strQueryComb & " WHERE DTC.seqvoodia = " & intSeqVooDiaComb
	strQueryComb = strQueryComb & "   AND DTC.seqtrecho = " & intSeqTrechoComb
	strQueryComb = strQueryComb & " GROUP BY ApDest.codiata "
	strQueryComb = strQueryComb & " ORDER BY 1, 2, 3 DESC "

	Dim objRsComb
	Set objRsComb = Server.CreateObject("ADODB.Recordset")
	objRsComb.Open strQueryComb, objConnComb

	Dim strDestinoCombAnterior, strDestinoCombNovo

	Do While (Not objRsComb.EOF)

		Dim strPaxAdtTran, strPaxChdTran, strPaxInfTran, strPesoBagagemTran, strPesoCargaTran
		strPaxAdtTran = "0"
		strPaxChdTran = "0"
		strPaxInfTran = "0"
		strPesoBagagemTran = "0"
		strPesoCargaTran = "0"

		Dim strPaxAdt2, strPaxChd2, strPaxInf2, strPesoBagagem, strPesoCarga
		strPaxAdt2 = "0"
		strPaxChd2 = "0"
		strPaxInf2 = "0"
		strPesoBagagem = "0"
		strPesoCarga = "0"

		Dim strDestinoComb
		strDestinoComb = objRsComb("DESTINO_COMB")
		If (IsVazio(strDestinoComb)) Then strDestinoComb = "&nbsp;"

		strDestinoCombAnterior = strDestinoComb

		Do While (Not objRsComb.EOF And _
		          (IsVazio(strDestinoCombNovo) Or (strDestinoCombAnterior = strDestinoCombNovo)))

			Dim strTipoEmbarque
			strTipoEmbarque = objRsComb("TIPO_EMBARQUE")

			If (strTipoEmbarque = "T") Then
				strPaxAdtTran = objRsComb("PAX_ADT")
				If (IsVazio(strPaxAdtTran)) Then strPaxAdtTran = "0"

				strPaxChdTran = objRsComb("PAX_CHD")
				If (IsVazio(strPaxChdTran)) Then strPaxChdTran = "0"

				strPaxInfTran = objRsComb("PAX_INF")
				If (IsVazio(strPaxInfTran)) Then strPaxInfTran = "0"

				strPesoBagagemTran = objRsComb("PESO_BAGAGEM")
				If (IsVazio(strPesoBagagemTran)) Then strPesoBagagemTran = "0"

				strPesoCargaTran = objRsComb("PESO_CARGA")
				If (IsVazio(strPesoCargaTran)) Then strPesoCargaTran = "0"
			ElseIf (strTipoEmbarque = "L") Then
				strPaxAdt2 = objRsComb("PAX_ADT")
				If (IsVazio(strPaxAdt2)) Then strPaxAdt2 = "0"

				strPaxChd2 = objRsComb("PAX_CHD")
				If (IsVazio(strPaxChd2)) Then strPaxChd2 = "0"

				strPaxInf2 = objRsComb("PAX_INF")
				If (IsVazio(strPaxInf2)) Then strPaxInf2 = "0"

				strPesoBagagem = objRsComb("PESO_BAGAGEM")
				If (IsVazio(strPesoBagagem)) Then strPesoBagagem = "0"

				strPesoCarga = objRsComb("PESO_CARGA")
				If (IsVazio(strPesoCarga)) Then strPesoCarga = "0"
			End If

			objRsComb.MoveNext
			If (Not objRsComb.EOF) Then
				strDestinoCombNovo = objRsComb("DESTINO_COMB")
			Else
				strDestinoCombNovo = "XXXXX"
			End If

		Loop

		Response.Write("			<tr style='text-align:right; font-size:6pt; font-weight:bold;'>" & vbCrLf)
		Response.Write("				<td style='text-align:center; font-size:7pt;' rowspan='2'>" & strDestinoComb & "</td>" & vbCrLf)
		Response.Write("				<td style='text-align:center; font-size:5pt; font-weight:normal;'>T</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxAdtTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxChdTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxInfTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoBagagemTran & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoCargaTran & "</td>" & vbCrLf)
		Response.Write("			</tr>" & vbCrLf)
		Response.Write("			<tr style='text-align:right; font-size:6pt; font-weight:bold;'>" & vbCrLf)
		Response.Write("				<td style='text-align:center; font-size:5pt; font-weight:normal;'>L</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxAdt2 & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxChd2 & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPaxInf2 & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoBagagem & "</td>" & vbCrLf)
		Response.Write("				<td style='padding-right:10px;'>" & strPesoCarga & "</td>" & vbCrLf)
		Response.Write("			</tr>" & vbCrLf)

	Loop

	objRsComb.Close
	Set objRsComb = Nothing

	objConnComb.Close()
	Set objConnComb = Nothing

End Sub

Sub PreencherTabelaCombinadaTotal()

	Dim intSeqVooDiaCombTotal, intSeqTrechoCombTotal
	intSeqVooDiaCombTotal = Request.QueryString("seqvoodia")
	intSeqTrechoCombTotal = Request.QueryString("seqtrecho")

	If (IsVazio(intSeqVooDiaCombTotal) Or IsVazio(intSeqTrechoCombTotal)) Then
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If

	Dim objConnCombTotal
	Set objConnCombTotal = CreateObject("ADODB.CONNECTION")
	objConnCombTotal.Open (StringConexaoSqlServer)
	objConnCombTotal.Execute "SET DATEFORMAT ymd"

	' **************
	' *** TRECHO ***
	' **************
	Dim strQueryTrecho
	strQueryTrecho = " SELECT "
	strQueryTrecho = strQueryTrecho & " COALESCE(DT.paxprimeira, 0) + COALESCE(DT.paxespecial, 0) + COALESCE(DT.paxeconomica, 0) + "
	strQueryTrecho = strQueryTrecho & "    COALESCE(DT.paxturismo, 0) - COALESCE(DT.paxchd, 0) PAX_ADT, "
	strQueryTrecho = strQueryTrecho & " DT.paxchd PAX_CHD, "
	strQueryTrecho = strQueryTrecho & " DT.paxinf PAX_INF, "
	strQueryTrecho = strQueryTrecho & " COALESCE(DT.baglivre, 0) + COALESCE(DT.bagexcesso, 0) PESO_BAGAGEM, "
	strQueryTrecho = strQueryTrecho & " COALESCE(DT.cargapaga, 0) + COALESCE(DT.cargagratis, 0) PESO_CARGA "
	strQueryTrecho = strQueryTrecho & " FROM sig_diariotrecho DT "
	strQueryTrecho = strQueryTrecho & " WHERE DT.seqvoodia = " & intSeqVooDiaCombTotal
	strQueryTrecho = strQueryTrecho & "   AND DT.seqtrecho = " & intSeqTrechoCombTotal

	Dim objRsTrecho
	Set objRsTrecho = Server.CreateObject("ADODB.Recordset")
	objRsTrecho.Open strQueryTrecho, objConnCombTotal

	If (objRsTrecho.EOF) Then
		objRsTrecho.Close()
		Set objRsTrecho = Nothing
		objConnCombTotal.Close()
		Set objConnCombTotal = Nothing
		Response.Write("<h1>Nenhum Registro foi encontrado.</h1>")
		Response.End
	End If

	' *********************
	' *** TOTAL A BORDO ***
	' *********************
	Dim strPaxAdtTotal
	strPaxAdtTotal = objRsTrecho("PAX_ADT")
	If (IsVazio(strPaxAdtTotal)) Then strPaxAdtTotal = "0"

	Dim strPaxChdTotal
	strPaxChdTotal = objRsTrecho("PAX_CHD")
	If (IsVazio(strPaxChdTotal)) Then strPaxChdTotal = "0"

	Dim strPaxInfTotal
	strPaxInfTotal = objRsTrecho("PAX_INF")
	If (IsVazio(strPaxInfTotal)) Then strPaxInfTotal = "0"

	Dim strPesoBagagemTotal
	strPesoBagagemTotal = objRsTrecho("PESO_BAGAGEM")
	If (IsVazio(strPesoBagagemTotal)) Then strPesoBagagemTotal = "0"

	Dim strPesoCargaTotal
	strPesoCargaTotal = objRsTrecho("PESO_CARGA")
	If (IsVazio(strPesoCargaTotal)) Then strPesoCargaTotal = "0"

	objRsTrecho.Close()
	Set objRsTrecho = Nothing

	objConnCombTotal.Close()
	Set objConnCombTotal = Nothing

	Response.Write("			<tr style='text-align:right; font-size:6pt; font-weight:bold; background-color:#E1E1E1;'>" & vbCrLf)
	Response.Write("				<td style='text-align:center; font-size:5pt; font-weight:normal;' colspan='2'>TOTAL</td>" & vbCrLf)
	Response.Write("				<td style='padding-right:10px;'>" & strPaxAdtTotal & "</td>" & vbCrLf)
	Response.Write("				<td style='padding-right:10px;'>" & strPaxChdTotal & "</td>" & vbCrLf)
	Response.Write("				<td style='padding-right:10px;'>" & strPaxInfTotal & "</td>" & vbCrLf)
	Response.Write("				<td style='padding-right:10px;'>" & strPesoBagagemTotal & "</td>" & vbCrLf)
	Response.Write("				<td style='padding-right:10px;'>" & strPesoCargaTotal & "</td>" & vbCrLf)
	Response.Write("			</tr>" & vbCrLf)

End Sub



Function IsVazio(var)

	If (IsEmpty(var) Or IsNull(var) Or (Trim(var) = "")) Then
		IsVazio = True
	Else
		IsVazio = False
	End If

End Function

Function FormataTextoBD(texto)

	FormataTextoBD = Replace(Replace(texto, " ", "&nbsp;"), vbCrLf, "<br/>")

End Function

%>
