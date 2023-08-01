import java.io.*;

public class Makemenu {
	public static void main(String[] args) {
		try {
			File f = new File(args[0]);
			FileInputStream fis = new FileInputStream(f);
			FileOutputStream fos = new FileOutputStream(args[1]);
			if(f.length() > 2048) throw new Exception("Bootloader may only be 2048 bytes max");
			for(int i = 0; i < 2048; i++) {
				if(fis.available() > 0) fos.write(fis.read());
				else fos.write(0);
			}
			fis.close();
			for(int i = 2; i < args.length; i+=2) {
				f = new File(args[i]);
				fis = new FileInputStream(f);
				String name = args[i+1];
				if(name.length() > 100) throw new Exception("ROM name too long");
				fos.write(33);
				int len = (int)f.length();
				int fulllen = len + 1 + 2 + name.length() + 1;
				if(len >= 16384) throw new Exception("ROM image too long");
				fos.write(fulllen >> 8);
				fos.write(fulllen & 0xFF);
				for(int j = 0; j < name.length(); j++) fos.write(name.charAt(j));
				fos.write(0);
				for(int j = 0; j < len; j++) fos.write(fis.read());
				fis.close();
				fos.flush();
			}
			fos.write(22);
			fos.close();
		}catch(Exception e) {
			System.err.println("Error:");
			e.printStackTrace();
			System.exit(1);
		}
	}
}
