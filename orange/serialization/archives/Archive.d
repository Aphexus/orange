/**
 * Copyright: Copyright (c) 2010 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Feb 6, 2010
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module orange.serialization.archives.Archive;

version (Tango)
	import tango.util.Convert;

import orange.serialization.archives.ArchiveException;

interface IArchive
{
	void beginArchiving ();
	void reset ();
}

abstract class Archive (U) : IArchive
{
	alias U[] DataType;
	
	abstract void beginArchiving ();
	abstract void beginUnarchiving (DataType data);
	abstract DataType data ();
	abstract void reset ();
	
	protected DataType toDataType (T) (T value)
	{
		try
			return to!(DataType)(value);
		
		catch (ConversionException e)
			throw new ArchiveException(e);
	}
	
	protected T fromDataType (T) (DataType value)
	{
		try
			return to!(T)(value);
		
		catch (ConversionException e)
			throw new ArchiveException(e);
	}
}