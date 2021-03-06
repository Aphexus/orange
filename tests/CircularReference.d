/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Nov 13, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module tests.CircularReference;

import orange.serialization.Serializer;
import orange.serialization.archives.XmlArchive;
import orange.test.UnitTester;
import tests.Util;

Serializer serializer;
XmlArchive!(char) archive;

class A
{
    B b;
    int x;
}

class B
{
    A a;
    int y;
}

A a;
B b;

unittest
{
    archive = new XmlArchive!(char);
    serializer = new Serializer(archive);

    a = new A;
    a.x = 3;

    b = new B;
    b.y = 4;

    b.a = a;
    a.b = b;

    describe("serialize objects with circular reference") in {
        it("should return a serialized object") in {
            auto expected = q"xml
<?xml version="1.0" encoding="UTF-8"?>
<archive version="1.0.0" type="org.dsource.orange.xml">
    <data>
        <object runtimeType="tests.CircularReference.A" type="tests.CircularReference.A" key="0" id="0">
            <object runtimeType="tests.CircularReference.B" type="tests.CircularReference.B" key="b" id="1">
                <reference key="a">0</reference>
                <int key="y" id="3">4</int>
            </object>
            <int key="x" id="4">3</int>
        </object>
    </data>
</archive>
xml";
            serializer.reset;
            serializer.serialize(a);

            assert(expected.equalToXml(archive.data));
        };
    };

    describe("deserialize objects with circular reference") in {
        it("should return a deserialized object equal to the original object") in {
            auto aDeserialized = serializer.deserialize!(A)(archive.untypedData);

            assert(a is a.b.a);
            assert(a.x == aDeserialized.x);
            assert(a.b.y == aDeserialized.b.y);
        };
    };
}
