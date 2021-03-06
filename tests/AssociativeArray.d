/**
 * Copyright: Copyright (c) 2011 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Aug 6, 2011
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module tests.AssociativeArray;

import orange.serialization.Serializer;
import orange.serialization.archives.XmlArchive;
import orange.test.UnitTester;
import tests.Util;

Serializer serializer;
XmlArchive!(char) archive;

class E
{
    int[int] aa;
}

E e;

unittest
{
    archive = new XmlArchive!(char);
    serializer = new Serializer(archive);

    e = new E;
    e.aa = [3 : 4, 1 : 2, 39 : 472, 6 : 7];

    describe("serialize associative array") in {
        it("should return a serialized associative array") in {
            auto expected2066 = q"xml
<?xml version="1.0" encoding="UTF-8"?>
<archive version="1.0.0" type="org.dsource.orange.xml">
    <data>
        <object runtimeType="tests.AssociativeArray.E" type="tests.AssociativeArray.E" key="0" id="0">
            <associativeArray keyType="int" length="4" valueType="int" key="aa" id="1">
                <key key="0">
                    <int key="0" id="2">1</int>
                </key>
                <value key="0">
                    <int key="0" id="3">2</int>
                </value>
                <key key="1">
                    <int key="1" id="4">3</int>
                </key>
                <value key="1">
                    <int key="1" id="5">4</int>
                </value>
                <key key="2">
                    <int key="2" id="6">6</int>
                </key>
                <value key="2">
                    <int key="2" id="7">7</int>
                </value>
                <key key="3">
                    <int key="3" id="8">39</int>
                </key>
                <value key="3">
                    <int key="3" id="9">472</int>
                </value>
            </associativeArray>
        </object>
    </data>
</archive>
xml";

            auto expected2067 = q"xml
<?xml version="1.0" encoding="UTF-8"?>
<archive version="1.0.0" type="org.dsource.orange.xml">
    <data>
        <object runtimeType="tests.AssociativeArray.E" type="tests.AssociativeArray.E" id="0" key="0">
            <associativeArray valueType="int" length="4" id="1" keyType="int" key="aa">
                <key key="0">
                    <int id="2" key="0">6</int>
                </key>
                <value key="0">
                    <int id="3" key="0">7</int>
                </value>
                <key key="1">
                    <int id="4" key="1">3</int>
                </key>
                <value key="1">
                    <int id="5" key="1">4</int>
                </value>
                <key key="2">
                    <int id="6" key="2">1</int>
                </key>
                <value key="2">
                    <int id="7" key="2">2</int>
                </value>
                <key key="3">
                    <int id="8" key="3">39</int>
                </key>
                <value key="3">
                    <int id="9" key="3">472</int>
                </value>
            </associativeArray>
        </object>
    </data>
</archive>
xml";
            static if (__VERSION__ >= 2067) auto expected = expected2067;
            else auto expected = expected2066;

            serializer.reset();
            serializer.serialize(e);

            assert(expected.equalToXml(archive.data));
        };
    };

    describe("deserialize associative array") in {
        it("should return an associative array equal to the original associative array") in {
            auto eDeserialized = serializer.deserialize!(E)(archive.untypedData);

            foreach (k, v ; eDeserialized.aa)
                assert(e.aa[k] == v);

            assert(e.aa == eDeserialized.aa);
        };
    };
}
