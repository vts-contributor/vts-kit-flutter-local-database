package com.viettel.vts_sqflite;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Constants between dart & Java world
 */

public class ConstantTest {

    @Test
    public void key() {
        assertEquals("com.viettel.vts_sqflite", Constant.PLUGIN_KEY);
    }
}
