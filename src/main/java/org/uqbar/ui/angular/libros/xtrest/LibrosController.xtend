package org.uqbar.ui.angular.libros.xtrest

import org.uqbar.commons.model.UserException
import org.uqbar.xtrest.api.Result
import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Delete
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.api.annotation.Put
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils
import uqbar.libros.domain.Biblioteca
import uqbar.libros.domain.Libro

/**
 * Ejemplo de controller REST/JSON en xtrest
 * 
 * @author jfernandes
 */
@Controller
class LibrosController {
	extension JSONUtils = new JSONUtils

	//	@Filter("/*")
	//	def defineJsonContentType(HandlerChain chain) {
	//		response.contentType = "application/json"
	//		chain.proceed
	//	}
	
	@Get("/libros")
	def Result libros() {
		val libros = Biblioteca.instance.todos
		response.contentType = ContentType.APPLICATION_JSON
		ok(libros.toJson)
	}

	@Get('/libros/:id')
	def Result libro() {
		val iId = Integer.valueOf(id)
		
		try {
			response.contentType = "application/json"
			ok(Biblioteca.instance.getLibro(iId).toJson)
		} 
		catch (UserException e) {
			notFound("No existe libro con id '" + id + "'");
		}
	}

	@Delete('/libros/:id')
	def Result eliminarLibro() {
		try {
			val iId = Integer.valueOf(id)
			val Biblioteca biblioteca = Biblioteca.instance
			biblioteca.eliminarLibro(biblioteca.getLibro(iId))
			ok('''{ "status" : "ok" }''')
		} catch (UserException e) {
			return notFound("No existe libro con id '" + id + "'");
		}
	}

	@Get('/libros/search')
	def Result buscar(String titulo) {
		ok(Biblioteca.instance.buscar(titulo).toJson)
	}

	@Post('/libros')
	def Result agregarLibro(@Body String body) {
		try {
			var nuevo = body.fromJson(Libro)

			nuevo.validar
			Biblioteca.instance.addLibro(nuevo.titulo, nuevo.autor)

			ok('''{ "id" : "«nuevo.id»" }''')
		} 
		catch (UserException e) {
			// badRequest(''' { "error" : "«e.message»" }''')
			badRequest(e.message)
		}
	}

	@Put('/libros/:id')
	def Result actualizar(@Body String body) {
		val actualizado = body.fromJson(Libro)
		if (Integer.parseInt(id) != actualizado.id) {
			return badRequest('{ "error" : "Id en URL distinto del cuerpo" }')
		}

		Biblioteca.instance.actualizarLibro(actualizado)
		ok('{ "status" : "OK" }');
	}

	def static void main(String[] args) {
		XTRest.start(LibrosController, 9200)
	}

}
