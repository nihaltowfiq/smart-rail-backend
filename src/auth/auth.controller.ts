import { Body, Controller, Post } from '@nestjs/common';
import { ApiBody, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { SigninDto } from './dto/signin.dto';
import { SignupDto } from './dto/signup.dto';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signup')
  @ApiOperation({ summary: 'User Signup' })
  @ApiBody({ type: SignupDto })
  signup(@Body() dto: SignupDto) {
    return this.authService.signup(dto.phone, dto.password);
  }

  @Post('signin')
  @ApiOperation({ summary: 'User Login' })
  @ApiBody({ type: SigninDto })
  signin(@Body() dto: SigninDto) {
    return this.authService.signin(dto.phone, dto.password);
  }
}
