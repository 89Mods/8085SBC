import java.io.*;

public class Makerom {
	public static void main(String[] args) {
		try {
			File f = new File(args[0]);
			FileInputStream fis = new FileInputStream(f);
			FileOutputStream fos = new FileOutputStream(args[1]);
			fos.write('C');
			fos.write('H');
			fos.write('I');
			fos.write('R');
			fos.write('P');
			fos.write(0);
			int len = (int)f.length();
			if(len >= 32*1024) throw new Exception("ROM too large");
			//fis.skip(33024);
			fos.write((len >> 8) & 0xFF);
			fos.write(len & 0xFF);
			while(fis.available() > 0) {
				fos.write(fis.read());
			}
			fos.close();
			fis.close();
		}catch(Exception e) {
			System.err.println("Error:");
			e.printStackTrace();
			System.exit(1);
		}
	}
}
