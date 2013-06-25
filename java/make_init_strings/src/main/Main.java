package main;

import java.io.*;

public class Main {
	public static void main(String[] args) throws IOException {
		final byte[] rawData = readFile(args[0]);
		final int nlen = rawData.length / 2;
		final byte[] lowerNibbles = new byte[nlen];
		final byte[] upperNibbles = new byte[nlen];

		for(int d = 0; d < nlen; ++d) {
			lowerNibbles[d] = (byte)((rawData[d * 2] & 0xF) | (rawData[d * 2 + 1] << 4));
			upperNibbles[d] = (byte)(((rawData[d * 2] >> 4) & 0xF) | (rawData[d * 2 + 1] & 0xF0));
		}

		System.out.println("Upper nibbles:");
		dumpArray(upperNibbles);

		System.out.println("Lower nibbles:");
		dumpArray(lowerNibbles);
	}

	private static void dumpArray(byte[] data) {
		for(int i = 0, line = 8; i < data.length; i += 32, ++line)
			System.out.println(makeLine(line, data, i));
	}

	private static CharSequence makeLine(int lineNumber, byte[] data, int offset) {
		final StringBuilder sb = new StringBuilder(100);
		sb.append("\t.INIT_");
		sb.append(String.format("%02X", lineNumber));
		sb.append("(256'h");
		for(int i = 31; i >= 0; --i)
			sb.append(String.format("%02X", data[offset + i]));
		sb.append("),");
		return sb;
	}

	private static byte[] readFile(final String fileName) throws IOException {
		final File f = new File(fileName);
		final byte[] b = new byte[((int) f.length() + 63) & ~63];
		drainInputStreamInto(b, new FileInputStream(f));
		return b;
	}

	private static void drainInputStreamInto(byte[] destination, InputStream is) throws IOException {
		int remaining = destination.length;
		int offset = 0;
		while (remaining > 0) {
			final int bytesRead = is.read(destination, offset, remaining);
			if (bytesRead == -1)
				break;
			offset += bytesRead;
			remaining -= bytesRead;
		}
	}


}
