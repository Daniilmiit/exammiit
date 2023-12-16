using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using System.Threading.Tasks;

namespace miitexam.Controllers
{
	[ApiController]
    [Route("api/[controller]")]
    public class HealthcheckController : ControllerBase
    {
        [HttpGet]
        public IActionResult CheckHealth()
        {
            // Perform your health checks here

            // Return 200 OK status and a message
            return Ok("API работает нормально!");
        }
    }
    [ApiController]
    [Route("api/[controller]")]
    public class CarController : ControllerBase
    {
        // Inject the session object
        private readonly IHttpContextAccessor _httpContextAccessor;
        private ISession Session => _httpContextAccessor.HttpContext.Session;

        public CarController(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        [HttpGet]
        public IActionResult GetCar()
        {
            // Retrieve car details from session
            var maker = Session.GetString("Maker");
            var model = Session.GetString("Model");

            return Ok(new { Maker = maker, Model = model });
        }

        [HttpPost("set")]
        public IActionResult SetCar([FromForm] string givenMaker, [FromForm] string givenModel)
        {
            // Store car details in session
            Session.SetString("Maker", givenMaker);
            Session.SetString("Model", givenModel);

            // Redirect to the GetCar() action method
            return RedirectToAction("GetCar");
        }
    }
	[ApiController]
    [Route("api/[controller]")]
    public class DriverController : ControllerBase
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private ISession Session => _httpContextAccessor.HttpContext.Session;

        public DriverController(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        [HttpGet]
        public IActionResult GetDriver()
        {
            var name = Session.GetString("DriverName");
            var age = Session.GetInt32("DriverAge");

            return Ok(new { Name = name, Age = age });
        }

        [HttpPost("set")]
        public IActionResult SetDriver([FromForm] string givenName, [FromForm] int givenAge)
        {
            Session.SetString("DriverName", givenName);
            Session.SetInt32("DriverAge", givenAge);

            return RedirectToAction("GetDriver");
        }
    }
}