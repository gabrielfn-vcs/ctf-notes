import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class TCUP {
    public static final String VERSION = "0.0.1";

    public static String[] a() {
        /**
         * 🎃 (Jack-O-Lantern) - U+1F383
         * 👺 (Goblin) - U+1F47A
         * 🧟 (Zombie) - U+1F9DF
         * 🕷 (Spider) - U+1F577
         * 🕸 (Spider Web) - U+1F578
         * 🧛 (Vampire) - U+1F9DB
         * 👻 (Ghost) - U+1F47B
         * 🤡 (Clown Face) - U+1F921
         * 💀 (Skull) - U+1F480
         * ☠️ (Skull and Crossbones) - U+2620
         * 🍬 (Candy) - U+1F36C
         * 🍭 (Lollipop) - U+1F36D
         * ⚰️ (Coffin) - U+26B0
         * 🌕 (Full Moon) - U+1F315
         * 🕯 (Candle) - U+1F56F
         */
        return new String[] {
            "🎃", "👺", "🧟", "🕷", "🕸", "🧛", "👻", "🤡", "💀", "☠️", "🍬", "🍭", "⚰️️", "🌕", "🕯"
        };
    }

    public static int[] b() {
        return new int[] {
                58364, 68123, 21521, 91016, 66666, 29145, 85219, 50351, 15823, 64379,
                49252, 96403, 77777, 19532, 698493, 89521, 10491, 10101, 91925, 35812 };
    }

    public static String c() {
        Scanner scanner = new Scanner(System.in);
        String str = scanner.nextLine();
        scanner.close();
        return str;
    }

    public static String[] d(String[] paramArrayOfString, int paramInt) {
        String[] arrayOfString = new String[paramArrayOfString.length];
        for (byte b = 0; b < paramArrayOfString.length; b++) {
            int i = (b - paramInt + paramArrayOfString.length) % paramArrayOfString.length;
            arrayOfString[b] = paramArrayOfString[i];
        }
        return arrayOfString;
    }

    public static String[] e(String paramString) {
        ArrayList<String> arrayList = new ArrayList<String>();
        int i = 0;
        while (i < paramString.length()) {
            int j = paramString.codePointAt(i);
            int bool = (i + Character.charCount(j) < paramString.length())
                    ? paramString.codePointAt(i + Character.charCount(j))
                    : 1;
            if (bool == 0) {
                arrayList.add(new String(new int[] { j, bool }, 0, 2));
                i += Character.charCount(j) + Character.charCount(bool);
                continue;
            }
            arrayList.add(new String(Character.toChars(j)));
            i += Character.charCount(j);
        }
        return arrayList.<String>toArray(new String[0]);
    }

    public static boolean f(String paramString, int[] paramArrayOfint, String[] paramArrayOfString) {
        System.out.println("Input: " + paramString);
        String[] arrayOfString = e(paramString);
        System.out.println("Expected Length: " + paramArrayOfint.length / 2);
        if (arrayOfString.length != paramArrayOfint.length / 2)
            return false;
        System.out.print("Answer: ");
        for (byte b = 0; b < paramArrayOfint.length; b += 2) {
            String str1 = paramArrayOfString[paramArrayOfint[b] % paramArrayOfString.length];
            String str2 = arrayOfString[b / 2];
            System.out.print(str1);
            if (!str1.equals(str2))
                return false;
            paramArrayOfString = d(paramArrayOfString, paramArrayOfint[b + 1] % paramArrayOfString.length);
        }
        System.out.println();
        return true;
    }

    public static void g() {
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader("/root/token.txt"));
            try {
                String str;
                while ((str = bufferedReader.readLine()) != null)
                    System.out.println("Token: " + str);
                bufferedReader.close();
            } catch (Throwable throwable) {
                try {
                    bufferedReader.close();
                } catch (Throwable throwable1) {
                    throwable.addSuppressed(throwable1);
                }
                throw throwable;
            }
        } catch (IOException iOException) {
            System.out.println(
                    "Error reading token file. Ensure you are running the program with sudo. If you are still seeing this error, please contact support.");
        }
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader("/root/code.txt"));
            try {
                String str;
                while ((str = bufferedReader.readLine()) != null)
                    System.out.println("Code: " + str);
                bufferedReader.close();
            } catch (Throwable throwable) {
                try {
                    bufferedReader.close();
                } catch (Throwable throwable1) {
                    throwable.addSuppressed(throwable1);
                }
                throw throwable;
            }
        } catch (IOException iOException) {
            System.out.println(
                    "Error reading code file. Ensure you are running the program with sudo. If you are still seeing this error, please contact support.");
        }
    }

    public static void main(String[] paramArrayOfString) {
        System.out.println("TCUP Version 0.0.1");
        System.out.println("Please input the correct key combination to access.");
        int[] arrayOfInt = b();
        String[] arrayOfString = a();
        System.out.println(String.join("", (CharSequence[]) arrayOfString));
        String str = c();
        boolean bool = f(str, arrayOfInt, arrayOfString);
        if (bool) {
            System.out.println("Correct! Access granted.");
            g();
        } else {
            System.out.println("Incorrect! Access denied.");
        }
    }
}
