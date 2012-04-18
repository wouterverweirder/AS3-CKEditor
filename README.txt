/*
 *  AS3 CKEditor wrapper
 *
 *  Copyright (c) 2012 Wouter Verweirder. All rights reserved.
 *
 *  It uses UniMotion on the native side:
 *  UniMotion - Unified Motion detection for Apple portables.
 *  Copyright (c) 2006 Lincoln Ramsay. All rights reserved.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License version 2.1 as published by the Free Software Foundation.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation Inc. 59 Temple Place, Suite 330, Boston MA 02111-1307 USA
 */

This library enables you to use CKEditor in your Flex (Web / AIR) applications.

Make sure you deploy ckeditor with your application, in a js subdirectory (see the demos for that).

Functionality is pretty basic & there are cross-browser issues when using the library in a Web application. Feel free to fork and fix those :)

Add the ckeditor namespace to your MXML file: xmlns:ckeditor="be.aboutme.as3.ckeditor.*"
And use the CKEditor tag in the application:

	<ckeditor:CKEditor id="editor1" width="100%" height="100%">
		<ckeditor:htmlText>
			<![CDATA[
				<p>This is <strong>a test<strong></p>
				<p>Does this work properly?</p>
			]]>
		</ckeditor:htmlText>
	</ckeditor:CKEditor>