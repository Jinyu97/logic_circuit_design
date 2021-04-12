/* Quartus II Version 4.2 Build 157 12/07/2004 SJ Full Version */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Cfg)
		Device PartName(EPXA4F672) Path("") File("decoder_7_SEG.sof") MfrSpec(OpMask(1));
	P ActionCode(Ign)
		Device PartName(EPXA-ARM922) MfrSpec(OpMask(0));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
