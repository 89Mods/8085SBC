using System;
using System.IO;

namespace Tholin8085 {
    class P8251 {
        public const uint S_TXRDY = 1;
        public const uint S_RXRDY = 2;
        public const uint S_TXEMPTY = 4;
        public const uint S_PE = 8;
        public const uint S_OE = 16;
        public const uint S_FE = 32;
        public const uint S_SYNDET = 64;
        public const uint S_DSR = 128;

        public uint mode,status;
        public uint txbuff,rxbuff;
        public bool waitingForMode;

        private bool txOn,rxOn;

        public P8251() {
            Reset();
        }

        public void Update() {
            if((status & S_TXEMPTY) == 0) {
                Console.Write(Char.ToString((char)txbuff));
                status |= S_TXEMPTY | S_TXRDY;
            }
            if(Console.KeyAvailable) {
                rxbuff = Console.ReadKey(true).KeyChar;
                if((status & S_RXRDY) == 0) {
                    status |= S_OE;
                }
                status |= S_RXRDY;
            }
        }

        public void Reset() {
            waitingForMode = true;
            status = S_TXEMPTY;
            txOn = false;
            rxOn = false;
        }

        public void SendByte(uint data, bool cd) {
            if(waitingForMode) {
                if(!cd) return;
                Console.WriteLine("P8251 mode set");
                mode = data;
                status |= S_TXRDY;
                waitingForMode = false;
                return;
            }
            if(cd) {
				Console.WriteLine("P8251 command");
                txOn = (data & 1) != 0;
                rxOn = (data & 4) != 0;
                if((data & 16) != 0) {
                    status &= ~(S_PE | S_OE | S_FE);
                }
                if((data & 64) != 0) {
                    Reset();
                    return;
                }
            }else {
                if(!txOn) return;
                txbuff = data;
                status &= ~(S_TXEMPTY | S_TXRDY);
            }
        }

        public uint ReadByte(bool cd) {
            if(waitingForMode) return 0;
            if(cd) {
                return status;
            }else {
                status &= ~(S_RXRDY);
                return rxbuff;
            }
        }
    }
    
    class MSM81C55 {
		public const uint S_TIMER = 64;
		
		public int[] RAM = new int[256];
		private uint command,status;
		private uint newTimerTop,newTimerOutMode;
		private uint timer,timerTop,timerOutMode;
		private bool timerStarted,stopAfterTC;
		public bool pendingIntr = false;
		
		public uint portb_inbuff;
		public uint porta_inbuff;
		private uint _portb_out;
		private uint _portc_out;
		
		public uint portb_out {
			get { return (command & 2) != 0 ? _portb_out : 0xFF; }
		}
		public uint portc_out {
			get { return (command & 4) != 0 ? _portc_out : 0xFF; }
		}
		
		public MSM81C55() {
			Reset();
		}
		
		public void Reset() {
				command = 0;
				status = 0;
				timer = 0;
				timerTop = 0;
				timerOutMode = 0;
				newTimerTop = 0;
				newTimerOutMode = 0;
				_portb_out = 0;
				_portc_out = 0;
				stopAfterTC = false;
				timerStarted = false;
				pendingIntr = false;
		}
		
		private int timerDiv = 0;
		
		public void UpdateTimer() {
			timerDiv++;
			if(timerDiv >= 1363) {
				timerDiv = 0;
				if(timerStarted) {
					timer--;
					if(timer == 0) {
							if(!stopAfterTC) {
									timer = timerTop;
									if(timerOutMode == 3) {
										pendingIntr = true;
									}
							}else {
									timerStarted = false;
									status |= S_TIMER;
									stopAfterTC = false;
							}
					}
				}
			}
		}
		
		private int counter = 0;
		public void Update() {
				counter++;
				if(counter >= 1024) {
						counter = 0;
						UpdateTimer();
				}
		}
		
		public void IOWrite(uint addr, uint val) {
			addr &= 0b111;
			val &= 0xFF;
			if(addr == 0) {
				command = val;
				uint tmrCmd = command >> 6;
				if(tmrCmd == 2) stopAfterTC = true;
				if(tmrCmd == 3) {
						timerTop = newTimerTop;
						timerOutMode = newTimerOutMode;
						timerStarted = true;
				}
				return;
			}
			switch(addr) {
					case 2:
						_portb_out = val;
						break;
					case 3:
						_portc_out = val;
						break;
					case 4:
						newTimerTop &= 0xFF00;
						newTimerTop |= val;
						break;
					case 5:
						newTimerTop &= 0x00FF;
						newTimerTop |= (val & 0b111111) << 8;
						newTimerOutMode = val >> 6;
						break;
			}
		}
		
		public uint IORead(uint addr) {
				addr &= 0b111;
				switch(addr) {
						case 0:
							uint res = status;
							status &= ~S_TIMER;
							return res;
						case 1:
							if((command & 1) != 0) return 0;
							return porta_inbuff;
						case 2:
							if((command & 2) != 0) return 0;
							return portb_inbuff;
						case 3:
							if((command & 4) != 0) return 0;
							return 0;
						case 4:
							return timer & 0xFF;
						case 5:
							return timer >> 8;
				}
				return 0;
		}
	}
	
	class OutputPort {
		public uint state;

		public OutputPort() {
			Reset();
		}

		public void Reset() {
			state = 0;
		}

		public void Write(uint data) {
			this.state = data;
		}
	}
	
	class SPIROM {
		public uint[] DATA = new uint[128*1024];
		
		private uint SDO;
		private bool inTransfer;
		private uint dataIn;
		private uint dataOut;
		private uint stepCounter;
		private bool prevClock;
		private bool waitingForCommand;
		private uint command;
		private bool needAddress;
		private uint address;
		private uint addressStep;
		
		public SPIROM(string filename) {
			byte[] romImage = File.ReadAllBytes(filename);
			for(int i = 0; i < Math.Min(romImage.Length, DATA.Length); i++) DATA[i] = (uint)(romImage[i] & 0xFF);
			Reset();
		}
		
		public void Reset() {
			SDO = 0;
			inTransfer = false;
		}
		
		public uint Update(uint CS, uint SCLK, uint SDI) {
			if(CS != 0) {
				inTransfer = false;
			}
			if(inTransfer) {
				if(CS != 0) inTransfer = false;
				if(SCLK != 0 && !prevClock) {
					dataIn = dataIn << 1;
					dataIn |= SDI;
					SDO = (dataOut >> 7) & 1;
					dataOut = dataOut << 1;
					stepCounter++;
					if(stepCounter == 8) {
						stepCounter = 0;
						if(waitingForCommand) {
							needAddress = false;
							if(dataIn == 0x90 || dataIn == 0x03) {
								command = dataIn;
								needAddress = true;
								address = 0;
								addressStep = 0;
								waitingForCommand = false;
							}
						}else if(needAddress) {
							address = address << 8;
							address |= dataIn;
							addressStep++;
							if(addressStep == 3) {
								needAddress = false;
							}
						}
						if(!needAddress) {
							if(command == 0x90) {
								dataOut = (address & 1) != 0 ? 0x15U : 0xEFU;
								address++;
								address &= 0xFF;
							}else if(command == 0x03) {
								dataOut = DATA[address % DATA.Length];
								address++;
							}
						}
						dataIn = 0;
					}
				}
			}else {
				if(CS == 0) {
					inTransfer = true;
					dataIn = 0;
					dataOut = 0;
					stepCounter = 0;
					waitingForCommand = true;
					needAddress = false;
					addressStep = 0;
				}
				SDO = 0;
			}
			prevClock = SCLK != 0;
			return SDO;
		}
	}
	
	class Emu8085 {
		public uint[] ROM = new uint[16384];
		public uint[] RAM = new uint[32768];
		
		private uint PC;
		private uint SP;
		private uint A;
		private uint B,C;
		private uint D,E;
		private uint H,L;
		
		private bool rst75En = false;
		private bool rst75Latch = false;
		private bool rst75Triggered = false;
		private bool ie = false;
		private bool intCooldown = false;
		
		private uint carry;
		private uint parity;
		private uint halfCarry;
		private uint zero;
		private uint sign;
		
		private bool slWEPrev;
		private bool slRSTPrev;
		
		private OutputPort extraOuts;
		private MSM81C55 ioports;
		private P8251 uart;
		private SPIROM spirom;
		
		public Emu8085(string filename) {
				byte[] romImage = File.ReadAllBytes("boot.bin");
				for(int i = 0; i < Math.Min(romImage.Length, ROM.Length); i++) ROM[i] = (uint)(romImage[i] & 0xFF);
				extraOuts = new OutputPort();
				ioports = new MSM81C55();
				uart = new P8251();
				spirom = new SPIROM(filename);
				Reset();
		}
		
		public void Reset() {
			PC = 0;
			A = 0;
			extraOuts.Reset();
			ioports.Reset();
			uart.Reset();
			spirom.Reset();
			slWEPrev = false;
			slRSTPrev = false;
			carry = parity = halfCarry = carry = 0;
			zero = 1;
			ioports.porta_inbuff = 2;
			rst75En = false;
			rst75Latch = false;
			rst75Triggered = false;
			ie = false;
			intCooldown = false;
		}
		
		private void MemWrite(uint addr, uint val) {
			if(addr < 32768) return;
			if(addr < 65536 - 256) RAM[addr - 32768] = val;
			else extraOuts.Write(val);
		}
		
		private uint MemRead(uint addr) {
			if(addr < 32768) return ROM[addr % ROM.Length];
			return RAM[addr - 32768];
		}
		
		private uint GetReg(uint idx) {
			switch(idx) {
				case 0:
					return B;
				case 1:
					return C;
				case 2:
					return D;
				case 3:
					return E;
				case 4:
					return H;
				case 5:
					return L;
				case 6:
					return MemRead(H << 8 | L);
				case 7:
					return A;
				default:
					return 0;
			}
		}
		
		private void SetReg(uint idx, uint val) {
			switch(idx) {
				case 0:
					B = val;
					break;
				case 1:
					C = val;
					break;
				case 2:
					D = val;
					break;
				case 3:
					E = val;
					break;
				case 4:
					H = val;
					break;
				case 5:
					L = val;
					break;
				case 6:
					MemWrite(H << 8 | L, val);
					break;
				case 7:
					A = val;
					break;
			}
		}
		
		private void IncPC() {
			PC++;
			PC &= 65535;
		}
		
		private void Jump(bool cond) {
			uint dest = MemRead(PC);
			IncPC();
			dest |= MemRead(PC) << 8;
			IncPC();
			if(cond) PC = dest;
		}
		
		private void Call(bool cond) {
			if(cond) Push(PC + 2);
			Jump(cond);
		}
		
		private void Ret(bool cond) {
			if(!cond) return;
			uint dest = Pop();
			PC = dest;
		}
		
		private uint Immediate() {
			uint res = MemRead(PC);
			IncPC();
			return res;
		}
		
		private void UpdateFlagsZSPFor(uint val) {
			zero = val == 0 ? 1U : 0U;
			sign = (val & 128) != 0 ? 1U : 0U;
			uint onesCount = 0;
			for(int i = 0; i < 8; i++) {
				if(((val >> i) & 1) != 0) onesCount++;
			}
			parity = onesCount % 2 == 0 ? 1U : 0U;
		}
		
		private void UpdateALogical(uint newA, bool test) {
			if(!test) A = newA;
			UpdateFlagsZSPFor(newA);
			carry = 0;
			halfCarry = 0;
		}
		
		private void AddA(uint toAdd, bool withCarry) {
			uint newA = A + toAdd + (withCarry && carry != 0 ? 1U : 0U);
			UpdateALogical(newA & 0xFF, true);
			if(newA > 255) {
				carry = 1;
				newA &= 255;
			}else carry = 0;
			if(((A >> 3) & 1) != 0 && ((newA >> 3) & 1) == 0) halfCarry = 1;
			else halfCarry = 0;
			A = newA;
		}
		
		private void SubA(uint toSub, bool withCarry, bool test) {
			uint newA = A - toSub - (withCarry && carry != 0 ? 1U : 0U);
			UpdateALogical(newA & 0xFF, true);
			if(newA > 255) {
				carry = 1;
				newA &= 255;
			}else carry = 0;
			if(((A >> 3) & 1) == 0 && ((newA >> 3) & 1) != 0) halfCarry = 1;
			else halfCarry = 0;
			if(!test) A = newA;
		}
		
		private void Push(uint val) {
			MemWrite(SP, val >> 8);
			SP--;
			SP &= 65535;
			MemWrite(SP, val & 0xFF);
			SP--;
			SP &= 65535;
		}
		
		private uint Pop() {
			SP++;
			SP &= 65535;
			uint val = MemRead(SP);
			SP++;
			SP &= 65535;
			val |= MemRead(SP) << 8;
			return val;
		}
		
		private void Tick() {
			ioports.Update();
			uint instr = MemRead(PC);
			IncPC();
			
			//http://www.bitsavers.org/components/intel/MCS80/MCS80_85_Users_Manual_Jan83.pdf - Page 89 onwards
			if((instr & 0b11000000) == 0b01000000 && instr != 0b01110110) {
				//MOV
				uint source = instr & 0b111;
				uint dest = (instr >> 3) & 0b111;
				SetReg(dest, GetReg(source));
			}else if(instr == 0b11110011) {
				//DI
				ie = false;
			}else if((instr & 0b11000111) == 0b00000110) {
				//MVI
				uint dest = (instr >> 3) & 0b111;
				SetReg(dest, MemRead(PC));
				IncPC();
			}else if(instr == 0b11111001) {
				//SPHL
				SP = (H << 8) | L;
			}else if(instr == 0b11000011) Jump(true); //JMP
			else if((instr & 0b11001111) == 0b00000001) {
				//LXI
				uint low = MemRead(PC);
				IncPC();
				uint high = MemRead(PC);
				IncPC();
				switch((instr >> 4) & 0b11) {
					case 0:
						B = high;
						C = low;
						break;
					case 1:
						D = high;
						E = low;
						break;
					case 2:
						H = high;
						L = low;
						break;
					case 3:
						SP = (high << 8) | low;
						break;
				}
			}else if(instr == 0b11010011) { 
				//OUT
				uint port = MemRead(PC);
				IncPC();
				ioports.IOWrite(port, A);
			}else if(instr == 0b11110110) UpdateALogical(A | Immediate(), false); //ORI
			else if(instr == 0b00110000) {
				//SIM
				rst75En = (A & 0b00001100) == 0b00001000;
				if((A & 0b00010000) != 0) {
					rst75Latch = false;
					rst75Triggered = false;
				}
			}else if(instr == 0b11111011) {
				//EI
				ie = true;
				intCooldown = true;
			}else if(instr == 0b11001101) Call(true); //CALL
			else if((instr & 0b11001111) == 0b11000101) {
				//PUSH
				switch((instr >> 4) & 0b11) {
					case 0:
						Push((B << 8) | C);
						break;
					case 1:
						Push((D << 8) | E);
						break;
					case 2:
						Push((H << 8) | L);
						break;
					case 3:
						uint flags = carry | (parity << 2) | (halfCarry << 4) | (zero << 6) | (sign << 7);
						Push((A << 8) | flags);
						break;
				}
			}else if(instr == 0b11101011) {
				//XCHG
				uint temp = D;
				D = H;
				H = temp;
				temp = E;
				E = L;
				L = temp;
			}else if(instr == 0b11000110) AddA(Immediate(), false); //ADI
			else if(instr == 0b11010010) Jump(carry == 0); //JNC
			else if((instr & 0b11001111) == 0b11000001) {
				//POP
				uint val = Pop();
				uint low = val & 0xFF;
				uint high = val >> 8;
				switch((instr >> 4) & 0b11) {
					case 0:
						B = high;
						C = low;
						break;
					case 1:
						D = high;
						E = low;
						break;
					case 2:
						H = high;
						L = low;
						break;
					case 3:
						A = high;
						carry = low & 1;
						parity = (low >> 2) & 1;
						halfCarry = (low >> 4) & 1;
						zero = (low >> 6) & 1;
						sign = (low >> 7) & 1;
						break;
				}
			}else if(instr == 0b11001001) Ret(true); //RET
			else if(instr == 0b11100110) UpdateALogical(A & Immediate(), false); //ANI
			else if(instr == 0b11111110) SubA(Immediate(), false, true); //CPI
			else if(instr == 0b11111010) Jump(sign != 0); //JM
			else if(instr == 0b11001010) Jump(zero != 0); //JZ
			else if((instr & 0b11001111) == 0b00000011) {
				//INX
				switch((instr >> 4) & 0b11) {
					case 0:
						C = (C + 1) & 0xFF;
						if(C == 0) B = (B + 1) & 0xFF;
						break;
					case 1:
						E = (E + 1) & 0xFF;
						if(E == 0) D = (D + 1) & 0xFF;
						break;
					case 2:
						L = (L + 1) & 0xFF;
						if(L == 0) H = (H + 1) & 0xFF;
						break;
					case 3:
						SP = (SP + 1) & 0xFFFF;
						break;
				}
			}
			else if(instr == 0b11011010) Jump(carry != 0); //JC
			else if(instr == 0b11011011) {
				//IN
				A = ioports.IORead(Immediate());
			}
			else if(instr == 0b00000111) {
				//RLC
				uint newA = (A << 1) & 0xFF;
				carry = (A >> 7) & 1;
				newA |= carry;
				A = newA;
			}
			else if(instr == 0b00001111) {
				//RRC
				uint newA = (A >> 1) & 0xFF;
				carry = A & 1;
				newA |= carry << 7;
				A = newA;
			}
			else if(instr == 0b00101111) A = (~A) & 0xFF; //CMA
			else if(instr == 0b00010111) {
				//RAL
				uint newA = (A << 1) & 0xFF;
				newA |= carry;
				carry = (A >> 7) & 1;
				A = newA;
			}else if(instr == 0b00011111) {
				//RAR
				uint newA = (A >> 1) & 0xFF;
				newA |= carry << 7;
				carry = A & 1;
				A = newA;
			}
			else if((instr & 0b11000111) == 0b00000100) {
				//INR
				uint reg = (instr >> 3) & 7;
				uint val = GetReg(reg);
				uint newval = (val + 1) & 0xFF;
				UpdateFlagsZSPFor(newval);
				if(((val >> 3) & 1) != 0 && ((newval >> 3) & 1) == 0) halfCarry = 1;
				SetReg(reg, newval);
			}
			else if((instr & 0b11000111) == 0b00000101) {
				//DCR
				uint reg = (instr >> 3) & 7;
				uint val = GetReg(reg);
				uint newval = (val - 1) & 0xFF;
				UpdateFlagsZSPFor(newval);
				if(((val >> 3) & 1) == 0 && ((newval >> 3) & 1) != 0) halfCarry = 1;
				SetReg(reg, newval);
			}
			else if(instr == 0b11000010) Jump(zero == 0); //JNZ
			else if(instr == 0b00110111) carry = 1; //STC
			else if(instr == 0b00111111) carry = carry != 0 ? 0U : 1U; //CMC
			else if((instr & 0b11111000) == 0b10111000) {
				//CMP
				uint reg = instr & 7;
				uint val = GetReg(reg);
				SubA(val, false, true);
			}
			else if((instr & 0b11111000) == 0b10101000) UpdateALogical(A ^ GetReg(instr & 7), false); //XRA
			else if((instr & 0b11111000) == 0b10000000) {
				//ADD
				uint reg = instr & 7;
				uint val = GetReg(reg);
				AddA(val, false);
			}
			else if(instr == 0b11001110) AddA(Immediate(), true); //ACI
			else if((instr & 0b11111000) == 0b10110000) UpdateALogical(A | GetReg(instr & 7), false); //ORA
			else if((instr & 0b11111000) == 0b10100000) UpdateALogical(A & GetReg(instr & 7), false); //ANA
			else if((instr & 0b11001111) == 0b00001011) {
				//DCX
				switch((instr >> 4) & 0b11) {
					case 0:
						C = (C - 1) & 0xFF;
						if(C == 0xFF) B = (B - 1) & 0xFF;
						break;
					case 1:
						E = (E - 1) & 0xFF;
						if(E == 0xFF) D = (D - 1) & 0xFF;
						break;
					case 2:
						L = (L - 1) & 0xFF;
						if(L == 0xFF) H = (H - 1) & 0xFF;
						break;
					case 3:
						SP = (SP - 1) & 0xFFFF;
						break;
				}
			}
			else if(instr == 0b00100010) {
				//SHLD
				uint addr = Immediate();
				addr |= Immediate() << 8;
				MemWrite(addr, L);
				MemWrite((addr + 1) & 0xFFFF, H);
			}
			else if(instr == 0b00101010) {
				//LHLD
				uint addr = Immediate();
				addr |= Immediate() << 8;
				L = MemRead(addr);
				H = MemRead((addr + 1) & 0xFFFF);
			}
			else if((instr & 0b11111000) == 0b10001000) {
				//ADC
				uint reg = instr & 7;
				uint val = GetReg(reg);
				AddA(val, true);
			}
			else if(instr == 0b01110110) Environment.Exit(0); //HLT
			else if(instr == 0b00111010) {
				//LDA
				uint addr = Immediate();
				addr |= Immediate() << 8;
				A = MemRead(addr);
			}
			else if(instr == 0b00110010) {
				//STA
				uint addr = Immediate();
				addr |= Immediate() << 8;
				MemWrite(addr, A);
			}
			else if(instr == 0b11011110) SubA(Immediate(), true, false); //SBI
			else if(instr == 0b11110010) Jump(sign == 0);
			else if((instr & 0b11100111) == 0b00000010) {
				//LDAX,STAX
				uint reg = (instr >> 4) & 1;
				uint addr;
				if(reg == 0) addr = (B << 8) | C;
				else addr = (D << 8) | E;
				reg = (instr >> 3) & 1;
				if(reg == 0) MemWrite(addr, A);
				else A = MemRead(addr);
			}
			else if((instr & 0b11111000) == 0b10010000) {
				//SUB
				uint reg = instr & 7;
				uint val = GetReg(reg);
				SubA(val, false, false);
			}
			else if((instr & 0b11111000) == 0b10011000) {
				//SBB
				uint reg = instr & 7;
				uint val = GetReg(reg);
				SubA(val, true, false);
			}
			else if(instr == 0b11010110) {
				//SUI
				uint val = Immediate();
				SubA(val, false, false);
			}
			else if(instr == 0b11001000) Ret(zero != 0); //RZ
			else if(instr == 0b11001100) Call(zero != 0); //CZ
			else if(instr == 0b11000100) Call(zero == 0); //CNZ
			else if(instr == 0b11101110) UpdateALogical(A ^ Immediate(), false); //XRI
			else if((instr & 0b11001111) == 0b00001001) {
				//DAD
				uint toAdd = 0;
				switch((instr >> 4) & 0b11) {
					case 0:
						toAdd = (B << 8) | C;
						break;
					case 1:
						toAdd = (D << 8) | E;
						break;
					case 2:
						toAdd = (H << 8) | L;
						break;
					case 3:
						toAdd = SP;
						break;
				}
				uint res = ((H << 8) | L) + toAdd;
				L = res & 255;
				H = (res >> 8) & 255;
				carry = res > 65535 ? 1U : 0U;
			}
			else if(instr != 0) {
				Console.WriteLine($"Invalid opcode {Convert.ToString(instr, 16)}");
				Environment.Exit(1);
			}
			
			ioports.UpdateTimer();
			
			//Handle slowbus here
			if(((ioports.portc_out >> 0) & 1) != 0) {
				uart.Reset();
				if(!slRSTPrev) Console.WriteLine("SL Reset");
				slRSTPrev = true;
			}else {
				bool slCS = ((extraOuts.state >> 5) & 1) != 0;
				bool slWE = ((ioports.portc_out >> 3) & 1) != 0;
				bool slRE = ((ioports.portc_out >> 2) & 1) != 0;
				bool slCD = ((ioports.portc_out >> 1) & 1) != 0;
				if(!slCS && !slWE && slWEPrev) {
					uart.SendByte(ioports.portb_out, slCD);
				}
				if(!slRE && slWE) {
					ioports.portb_inbuff = uart.ReadByte(slCD);
				}
				slWEPrev = slWE;
				slRSTPrev = false;
				uart.Update();
			}
			
			uint SDO = spirom.Update(extraOuts.state & 1, (extraOuts.state & 2) >> 1, (extraOuts.state & 4) >> 2);
			ioports.porta_inbuff = (ioports.porta_inbuff & 0xFE) | SDO;
			
			if(ioports.pendingIntr) {
				ioports.pendingIntr = false;
				rst75Latch = true;
			}
			
			if(rst75Latch && !rst75Triggered && rst75En && ie && !intCooldown) {
				rst75Triggered = true;
				//TODO: Interrupt here
			}
			
			intCooldown = false;
		}
		
		static void Main(string[] args) {
			if(args.Length < 1) {
				Console.WriteLine("Error: Must specify an input file");
				Environment.Exit(1);
				return;
			}
			
			Emu8085 emu = new Emu8085(args[0]);
			emu.Reset();
			while(true) {
				emu.Tick();
			}
		}
	}
}
