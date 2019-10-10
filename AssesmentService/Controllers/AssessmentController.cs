using System;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.EventHubs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace AssesmentService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AssessmentController : ControllerBase
    {

        private readonly ILogger<AssessmentController> _logger;
        private IConfiguration _configuration;

        public AssessmentController(ILogger<AssessmentController> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
        }

        public ActionResult Get([FromServices]IConfiguration configuration)
        {
            var sb = new StringBuilder();
            foreach (var env in configuration.GetChildren())
            {
                sb.AppendLine($"{env.Key}:{ env.Value}");
            }

            return Ok(sb.ToString());
        }

        [HttpPost]
        public async Task<ActionResult> Post([FromBody] UserAssessmentInput input)
        {
            try
            {
                var ev = ProcessAssessment(input);
                await SendEventToHubAsync(ev);
            }
            catch (Exception e)
            {
                _logger.LogError(500, e, "An error happened while trying to process a user assessment");
            }

            return Ok();
        }

        private static AssessmentEvent ProcessAssessment(UserAssessmentInput input)
        {
            var eventType = input.Answer ? EventType.AssessmentPassed : EventType.AssessmentFailed;

            return new AssessmentEvent
            {
                UserId = input.UserId,
                EventDate = DateTime.UtcNow,
                EventType = eventType,
                Meta = JsonConvert.SerializeObject(input)
            };
        }

        private async Task SendEventToHubAsync(AssessmentEvent @event)
        {
            var connectionStringBuilder = new EventHubsConnectionStringBuilder(_configuration["EventHubConnectionString"])
            {
                EntityPath = _configuration["EventHubName"]
            };

            var eventHubClient = EventHubClient.CreateFromConnectionString(connectionStringBuilder.ToString());

            await eventHubClient.SendAsync(new EventData(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(@event))));

        }

        public class UserAssessmentInput
        {
            public Guid UserId { get; set; }
            public int AssessmentId { get; set; }
            public bool Answer { get; set; }
        }

        public class AssessmentEvent
        {
            public Guid UserId { get; set; }
            public DateTime EventDate { get; set; }
            public EventType EventType { get; set; }
            public string Meta { get; set; }
        }

        public enum EventType
        {
            AssessmentPassed,
            AssessmentFailed
        }

        //[HttpGet]
        //public IEnumerable<WeatherForecast> Get()
        //{
        //    var rng = new Random();
        //    return Enumerable.Range(1, 5).Select(index => new WeatherForecast
        //    {
        //        Date = DateTime.Now.AddDays(index),
        //        TemperatureC = rng.Next(-20, 55),
        //        //Summary = Summaries[rng.Next(Summaries.Length)]
        //    })
        //    .ToArray();
        //}
    }
}
