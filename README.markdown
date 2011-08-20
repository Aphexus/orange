## Introduction

Orange is a serialization library for the D programming language.It supports D1/Tango and D2/Phobos.
It can serialize most of the available types in D, including third party types and can serialize
through base class references. It supports fully automatic serialization of all supported types
and also supports several ways to customize the serialization. Orange has a separate front end
(the serializer) and back end (the archive) making it possible for the user to create new archive
types that can be used with the existing serializer. 

## Build Dependencies

Make or [DSSS](http://dsource.org/projects/dsss) 

## Building

1. Clone the repository
2. Build the library either using make or dsss

## Unit Tests

To run the unit test run the shell script "unittest.sh":

	$ ./unittest.sh

## Simple Usage Example

	module main;

	import orange.core._;
	import orange.serialization._;
	import orange.serialization.archives._;

	class Foo
	{
		int a;
	}

	void main ()
	{
		auto foo = new Foo; // create something to serialize
		foo.a = 3; // change the default value of "a"
	
		auto archive = new XMLArchive!(char); // create an XML archive
		auto serializer = new Serializer(archive); // create the serializer
	
		serializer.serialize(foo); // serialize "foo"
		
		// deserialize the serialized data as an instance of "Foo"
		auto f = serializer.deserialize!(Foo)(archive.untypedData);
		
		// verify that the deserialized value is equal to the original value
		assert(f.a == foo.a);
	}

## Detailed Build Instructions

Clone the repository:

	$ git clone git://github.com/jacob-carlborg/orange.git
	
Change to the new directory "orange"

	$ cd orange

Build the library by running one of the following:
	
	$ dsss build
Or

	$ make