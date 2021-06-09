using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FEWebApplication.Controladores.Core
{
    [ApiController]
    [Produces("application/json")]
    public abstract class COApiController : ControllerBase
    {
    }
}
